//
//  CalculatorView.swift
//  CalculatorApp
//
//  Created by 최민규 on 6/7/25.
//

import SwiftUI
import UIKit

struct CalculatorView: View {
    @State private var inputSequence: String = ""  // 사용자가 누른 버튼들의 순서
    @State private var calculationResult: Double? = nil  // 계산 결과
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .backspace, .divide],
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
                                if [.add, .subtract, .multiply, .divide, .equal, .backspace, .negative].contains(item) {
                                    Image(systemName: item.rawValue)
                                        .font(.system(size: 24))
                                        .frame(
                                            width: self.buttonWidth(item: item),
                                            height: max(48, self.buttonHeight())
                                        )
                                        .background(item.buttonColor)
                                        .foregroundColor(item.fontColor)
                                        .cornerRadius(max(48, self.buttonHeight())/2)
                                } else if item == .clear {
                                    Text("AC")
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
                                        .font(.system(size: 32))
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
            case .add, .subtract, .multiply, .divide, .decimal:
                // 연산자를 누르면 결과값 + 연산자를 inputSequence에 설정
                inputSequence = formatResult(calculationResult!) + button.displayValue
                calculationResult = nil
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .doubleZero:
                // 숫자를 누르면 새로운 입력 시작
                inputSequence = ""
                calculationResult = nil
                // 새로운 숫자 입력
                inputSequence += button.displayValue
            case .clear:
                inputSequence = ""
                calculationResult = nil
            case .equal, .backspace, .negative:
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
            case .add, .subtract, .multiply, .divide:
                if inputSequence.isEmpty {
                    if button == .subtract {
                        inputSequence = "-"
                    }
                    return
                }
                
                // 마지막 연산자와 그 이전 문자 확인
                if let lastChar = inputSequence.last {
                    let lastCharStr = String(lastChar)
                    
                    // ×- 또는 ÷-로 끝나는 경우
                    if lastCharStr == "-" && inputSequence.count >= 2 {
                        let secondLastChar = inputSequence[inputSequence.index(inputSequence.endIndex, offsetBy: -2)]
                        let secondLastCharStr = String(secondLastChar)
                        
                        if secondLastCharStr == "×" || secondLastCharStr == "÷" {
                            switch button {
                            case .add:
                                // ×- 또는 ÷-를 +로 변경
                                inputSequence.removeLast(2)
                                inputSequence += "+"
                            case .subtract:
                                // ×- 또는 ÷- 유지
                                return
                            case .multiply:
                                // ×- 또는 ÷-를 ×로 변경
                                inputSequence.removeLast(2)
                                inputSequence += "×"
                            case .divide:
                                // ×- 또는 ÷-를 ÷로 변경
                                inputSequence.removeLast(2)
                                inputSequence += "÷"
                            default:
                                break
                            }
                            return
                        }
                    }
                    
                    // 일반적인 연산자 처리
                    if ["+", "-", "×", "÷"].contains(lastCharStr) {
                        // × 또는 ÷ 뒤에 -가 오는 경우
                        if button == .subtract && (lastCharStr == "×" || lastCharStr == "÷") {
                            inputSequence += "-"
                            return
                        }
                        
                        // 마지막 연산자를 새로운 연산자로 교체
                        inputSequence.removeLast()
                    }
                }
                inputSequence += button.displayValue
                
            case .decimal:
                inputSequence += "."
            case .clear:
                inputSequence = ""
                calculationResult = nil
            case .equal:
                calculateResult()
                inputSequence = ""
            case .negative:
                if inputSequence.isEmpty {
                    return
                }
                
                // 마지막이 숫자인지 확인
                if let lastChar = inputSequence.last, !CalcButton.operators.contains(String(lastChar)) {
                    // 마지막 숫자(a)의 시작 위치 찾기
                    var numberStartIndex = inputSequence.count - 1
                    while numberStartIndex >= 0 {
                        let char = inputSequence[inputSequence.index(inputSequence.startIndex, offsetBy: numberStartIndex)]
                        if CalcButton.operators.contains(String(char)) {
                            break
                        }
                        numberStartIndex -= 1
                    }
                    
                    // a와 b 분리
                    let a = inputSequence[inputSequence.index(inputSequence.startIndex, offsetBy: numberStartIndex + 1)...]
                    let b = numberStartIndex >= 0 ? String(inputSequence[..<inputSequence.index(inputSequence.startIndex, offsetBy: numberStartIndex + 1)]) : ""
                    
                    // b 변환
                    let newB: String
                    if b.isEmpty {
                        newB = "-"
                    } else {
                        // 마지막 연산자 찾기
                        let lastOperator = b.last!
                        let lastOperatorStr = String(lastOperator)
                        
                        // ×- 또는 ÷- 처리
                        if lastOperatorStr == "-" && b.count >= 2 {
                            let secondLastChar = b[b.index(b.endIndex, offsetBy: -2)]
                            if String(secondLastChar) == "×" || String(secondLastChar) == "÷" {
                                newB = String(b.dropLast(2)) + String(secondLastChar)
                                inputSequence = newB + a
                                return
                            }
                        }
                        
                        // 일반 연산자 변환
                        if let button = CalcButton.getOperatorButton(for: lastOperatorStr) {
                            // b가 맨 앞에 있는 경우(인덱스 0을 포함)
                            if numberStartIndex == 0 {
                                // -를 삭제
                                newB = ""
                            } else {
                                newB = String(b.dropLast()) + button.toggledOperator
                            }
                        } else {
                            newB = b
                        }
                    }
                    
                    // 새로운 문자열 조합
                    inputSequence = newB + a
                }
            case .backspace:
                // inputSequence가 비어있지 않은 경우에만 동작
                guard !inputSequence.isEmpty else { return }
                inputSequence.removeLast()
            }
        }
    }
    
    func resetCalculator() {
        inputSequence = ""
        calculationResult = nil
    }
    
    func calculateResult() {
        guard !inputSequence.isEmpty else { return }
        
        // 마지막 연산자 제거
        while let lastChar = inputSequence.last, ["+", "-", "×", "÷"].contains(String(lastChar)) {
            inputSequence.removeLast()
        }
        
        // ×- 또는 ÷-로 끝나는 경우 처리
        if inputSequence.hasSuffix("×-") || inputSequence.hasSuffix("÷-") {
            inputSequence.removeLast(2)
        }
        
        // 모든 숫자를 Double로 변환
        var expression = inputSequence
        let numberPattern = "\\d+(\\.\\d+)?"
        if let regex = try? NSRegularExpression(pattern: numberPattern) {
            let matches = regex.matches(in: expression, range: NSRange(expression.startIndex..., in: expression))
            for match in matches.reversed() {
                if let range = Range(match.range, in: expression) {
                    let number = expression[range]
                    if let doubleValue = Double(number) {
                        // 정확한 Double 값 유지
                        expression = expression.replacingCharacters(in: range, with: String(doubleValue))
                    }
                }
            }
        }
        
        // ×를 *로, ÷를 /로 변환
        expression = expression
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
        // 소수점이 있는 경우 정확한 값 표시
        return String(number)
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.height * 0.37 - (6*12)) / 5
    }
}
