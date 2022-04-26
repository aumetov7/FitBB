//
//  TextExtension.swift
//  FitBB
//
//  Created by Акбар Уметов on 26/4/22.
//
import SwiftUI

extension Text {
    func makeRound() -> some View {
        self
            .font(.system(.body, design: .rounded))
            .fontWeight(.medium)
            .kerning(0.5)
    }
    
    func signText() -> some View {
        self
            .fontWeight(.light)
            .font(.system(.callout))
            .foregroundColor(.black)
    }
}
