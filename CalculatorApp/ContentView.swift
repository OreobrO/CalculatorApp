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
    case add = "+"
    case subtract = "-"
    case divide = "/"
    case multiply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .main
        case .clear, .negative, .percent:
            return Color.gray3
        default:
            return Color.gray2
        }
    }
    
    var fontColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .main
        case .clear, .negative, .percent:
            return Color.gray3
        default:
            return Color.gray2
        }
    }
}


struct ContentView: View {
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    var body: some View {
        ZStack {
            Color.gray1.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                //Text display
                HStack {
                    Spacer()
                    Text("0")
                        .bold()
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                }//Result
                .padding()
                
                // Our buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight() )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonHeight()/2)
                            })
                        }//ForEach item
                    }//HStack
                }//ForEach row
                .padding(.bottom, 4)
            }//VStack
        }
    }
    
    func didTap(Button: CalcButton) {
        
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.height * 2 / 5 - (6*12)) / 5
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
