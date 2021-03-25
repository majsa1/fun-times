//
//  Button.swift
//  FunTimes
//
//  Created by Marjo Salo on 19/03/2021.
//

import SwiftUI

struct ColorButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 6.0))
            .overlay(RoundedRectangle(cornerRadius: 6.0).stroke(Color.gray, lineWidth: 1))
            .shadow(color: .gray, radius: 2)
            .foregroundColor(.white)
    }
}

extension View {
    func colorButton() -> some View {
        self.modifier(ColorButton())
    }
}
