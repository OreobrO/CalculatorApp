import SwiftUI

enum Currency: String, CaseIterable {
    case usd = "USD"
    case krw = "KRW"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case cny = "CNY"
    case aud = "AUD"
    case cad = "CAD"
    case chf = "CHF"
    case inr = "INR"
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .krw: return "₩"
        case .eur: return "€"
        case .gbp: return "£"
        case .jpy: return "¥"
        case .cny: return "¥"
        case .aud: return "A$"
        case .cad: return "C$"
        case .chf: return "Fr"
        case .inr: return "₹"
        }
    }
    
    var description: String {
        switch self {
        case .usd: return "United States Dollar"
        case .krw: return "Korean Won"
        case .eur: return "Euro"
        case .gbp: return "British Pound"
        case .jpy: return "Japanese Yen"
        case .cny: return "Chinese Yuan"
        case .aud: return "Australian Dollar"
        case .cad: return "Canadian Dollar"
        case .chf: return "Swiss Franc"
        case .inr: return "Indian Rupee"
        }
    }
    
    var displayText: String {
        return "\(symbol) (\(description))"
    }
}
