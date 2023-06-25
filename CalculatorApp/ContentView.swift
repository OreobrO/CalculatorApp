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
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    
    @State var isCalculationStarted: Bool = false
    @State var view = ""
    @State var value = ""
    @State var plusMinus = ""
    @State var multiplyDivide = ""
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .doubleZero, .decimal, .equal],
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
                            Text((Double(view) ?? 0.0).truncatingRemainder(dividingBy: 1.0) == 0 ? String(Int(Double(view) ?? 0.0)) : view)
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(.black)
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
                                self.didTap(button: item)
                            }, label: {
                                if [.add, .subtract, .divide, .multiply, .equal, .percent, .negative].contains(item) {
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
    
    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button == .add {
                self.isCalculationStarted = true
                self.value = String(Double(self.view)!)
                self.view = String(evaluateExpression(plusMinus + multiplyDivide + value)!)
                self.value = String(Double(self.view)!)
                self.plusMinus += self.value + "+"
                self.multiplyDivide = ""
                self.value = ""
            }
            else if button == .subtract {
                self.isCalculationStarted = true
                self.value = String(Double(self.view)!)
                self.view = String(evaluateExpression(plusMinus + multiplyDivide + value)!)
                self.value = String(Double(self.view)!)
                self.plusMinus += self.value + "-"
                self.multiplyDivide = ""
                self.value = ""
            }
            else if button == .multiply {
                self.isCalculationStarted = true
                self.value = String(Double(self.view)!)
                self.view = String(evaluateExpression(multiplyDivide + value)!)
                self.multiplyDivide += self.value + "*"
                self.value = ""
            }
            else if button == .divide {
                self.isCalculationStarted = true
                self.value = String(Double(self.view)!)
                self.view = String(evaluateExpression(multiplyDivide + value)!)
                self.multiplyDivide += self.value + "/"
                self.value = ""
            }
            else if button == .equal {
                self.isCalculationStarted = true
                self.value = String(Double(self.view)!)
                self.view = String(evaluateExpression(plusMinus + multiplyDivide + value)!)
                self.plusMinus = ""
                self.multiplyDivide = ""
                self.value = ""
            }
        case .clear:
            self.isCalculationStarted = false
            self.view = ""
            self.value = ""
            self.plusMinus = ""
            self.multiplyDivide = ""
        case .decimal:
            if !view.contains(".") {
                self.view += "."
            } else {
                break
            }
        case .negative, .percent:
            break
        default:
            let number = button.rawValue
            if !isCalculationStarted {
                self.view += number
            } else {
                self.view = number
                isCalculationStarted = false
            }
        }
    }
    
    func evaluateExpression(_ expression: String) -> Double? {
        if let result = NSExpression(format: expression).expressionValue(with: nil, context: nil) as? Double {
            return result
        } else {
            return nil
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.height * 0.37 - (6*12)) / 5
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
