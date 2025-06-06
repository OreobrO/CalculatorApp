//
//  ContentView.swift
//  CalculatorApp
//
//  Created by 최민규 on 2023/06/11.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case doubleZero = "00"
    case add = "plus"
    case subtract = "minus"
    case divide = "divide"
    case multiply = "multiply"
    case equal = "equal"
    case clear = "AC"
    case decimal = "."
    case percent = "percent"
    case negative = "plus.forwardslash.minus"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .main
        case .clear, .negative, .percent:
            return .gray3
        default:
            return .gray2
        }
    }
    
    var fontColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .white
        case .clear, .negative, .percent:
            return .black
        default:
            return .black
        }
    }
    
    var displayValue: String {
        switch self {
        case .multiply: return "×"
        case .divide: return "÷"
        case .add: return "+"
        case .subtract: return "-"
        case .equal: return "="
        case .clear: return "AC"
        case .negative: return "±"
        case .percent: return "%"
        case .decimal: return "."
        default: return self.rawValue
        }
    }
}

struct ContentView: View {
    @State private var inputSequence: String = ""  // 사용자가 누른 버튼들의 순서
    @State private var calculationResult: Double? = nil  // 계산 결과
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .doubleZero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.gray1.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                //Text display
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 100)
                        .foregroundColor(.gray2)
                    
                    HStack {
                        Image(systemName: "wonsign")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .opacity(0.3)
                        Spacer()
                        VStack {
                            if let result = calculationResult {
                                Text(formatResult(result))
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundColor(.black)
                            } else {
                                Text(inputSequence.isEmpty ? "0" : inputSequence)
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundColor(.black)
                            }
                        }
                    }//HStack
                    .frame(height: 100)
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 16)
                // Our buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                handleButtonPress(item)
                            }, label: {
                                if [.add, .subtract, .multiply, .divide, .equal, .percent, .negative].contains(item) {
                                    Image(systemName: item.rawValue)
                                        .font(.system(size: 24))
                                        .frame(
                                            width: self.buttonWidth(item: item),
                                            height: max(48, self.buttonHeight())
                                        )
                                        .background(item.buttonColor)
                                        .foregroundColor(item.fontColor)
                                        .cornerRadius(max(48, self.buttonHeight())/2)
                                } else {
                                    Text(item.rawValue)
                                        .font(.system(size: item == .clear ? 24: 32))
                                        .frame(
                                            width: self.buttonWidth(item: item),
                                            height: max(48, self.buttonHeight())
                                        )
                                        .background(item.buttonColor)
                                        .foregroundColor(item.fontColor)
                                        .cornerRadius(max(48, self.buttonHeight())/2)
                                }
                            })
                        }//ForEach item
                    }//HStack
                }//ForEach row
                .padding(.bottom, 4)
            }//VStack
            .padding()
        }
    }
    
    func handleButtonPress(_ button: CalcButton) {
        // 계산 결과가 있을 때
        if calculationResult != nil {
            switch button {
            case .add, .subtract, .multiply, .divide:
                // 연산자를 누르면 결과값 + 연산자를 inputSequence에 설정
                inputSequence = formatResult(calculationResult!) + button.displayValue
                calculationResult = nil
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .doubleZero, .decimal:
                // 숫자를 누르면 새로운 입력 시작
                inputSequence = ""
                calculationResult = nil
                // 새로운 숫자 입력
                inputSequence += button.displayValue
            case .clear:
                inputSequence = ""
                calculationResult = nil
            case .equal, .percent, .negative:
                // 특수 기능은 무시
                break
            }
        } else {
            // 계산 결과가 없을 때는 기존 로직대로 처리
            switch button {
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
                inputSequence += button.displayValue
            case .doubleZero:
                inputSequence += "00"
            case .add:
                inputSequence += "+"
            case .subtract:
                inputSequence += "-"
            case .multiply:
                inputSequence += "×"
            case .divide:
                inputSequence += "÷"
            case .decimal:
                inputSequence += "."
            case .clear:
                resetCalculator()
            case .equal:
                calculateResult()
            case .negative, .percent:
                // 특수 기능은 나중에 구현
                break
            }
        }
    }
    
    func resetCalculator() {
        inputSequence = ""
        calculationResult = nil
    }
    
    func calculateResult() {
        // 입력이 비어있으면 계산하지 않음
        guard !inputSequence.isEmpty else { return }
        
        // ×를 *로, ÷를 /로 변환
        var expression = inputSequence
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
        
        do {
            // NSExpression을 사용하여 수식 계산
            let result = try NSExpression(format: expression).expressionValue(with: nil, context: nil) as? Double
            
            // 결과가 너무 큰 경우 처리
            if let result = result {
                if abs(result) > Double.greatestFiniteMagnitude {
                    calculationResult = nil
                    inputSequence = "Error: Too large"
                    return
                }
                calculationResult = result
            }
        } catch {
            // 계산 오류 처리
            calculationResult = nil
            inputSequence = "Error"
        }
    }
    
    func formatResult(_ number: Double) -> String {
        // 소수점 이하가 0인 경우 정수로 표시
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(number))
        }
        // 소수점이 있는 경우 소수점 둘째 자리까지 표시
        return String(format: "%.2f", number)
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.height * 0.37 - (6*12)) / 5
    }
}

#Preview {
    ContentView()
}
