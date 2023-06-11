//
//  Colors.swift
//  CalculatorApp
//
//  Created by 최민규 on 2023/06/11.
//

import SwiftUI

extension Color {
    init(hex: UInt) {
        let red = Double((hex >> 16) & 0xff) / 255.0
        let green = Double((hex >> 8) & 0xff) / 255.0
        let blue = Double(hex & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue)
    }

    static let main = Color(hex: 0x4F75FF)
    static let gray1 = Color(hex: 0xF7F7F7)
    static let gray2 = Color(hex: 0xEBEBEB)
    static let gray3 = Color(hex: 0xD9D9D9)
}
