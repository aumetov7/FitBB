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
    }
    
    func chatBubbleText() -> some View {
        self
            .padding(.all, 20)
            .foregroundColor(.white)
            .background(Color.blue)
    }
    
    func titleText() -> some View {
        self
            .font(.largeTitle)
            .fontWeight(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
    
    func roundedTitle(alignment: Alignment, padding: Edge.Set) -> some View {
        self
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.black)
            .frame(maxWidth: .infinity, alignment: alignment)
            .padding(padding)
    }
}

extension TextField {
    func textField() -> some View {
        self
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
    }
}
