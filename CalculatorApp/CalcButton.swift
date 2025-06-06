
import SwiftUI

enum CalcButton: String, CaseIterable {
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
    case backspace = "delete.backward"
    case negative = "plus.forwardslash.minus"
    
    static let operators = ["+", "-", "×", "÷"]
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .main
        case .clear, .negative, .backspace:
            return .gray3
        default:
            return .gray2
        }
    }
    
    var fontColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .white
        case .clear, .negative, .backspace:
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
        case .backspace: return "􁂈"
        case .decimal: return "."
        default: return self.rawValue
        }
    }
    
    var isOperator: Bool {
        return Self.operators.contains(self.displayValue)
    }
    
    var isNegativeOperator: Bool {
        return self.displayValue == "-"
    }
    
    var isMultiplyOrDivide: Bool {
        return self.displayValue == "×" || self.displayValue == "÷"
    }
    
    var toggledOperator: String {
        switch self.displayValue {
        case "×": return "×-"
        case "×-": return "×"
        case "÷": return "÷-"
        case "÷-": return "÷"
        case "+": return "-"
        case "-": return "+"
        default: return self.displayValue
        }
    }
    
    static func getOperatorButton(for displayValue: String) -> CalcButton? {
        return allCases.first { $0.displayValue == displayValue }
    }
}
