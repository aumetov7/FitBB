//
//  FoodView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct FoodView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Food")
                    .titleText()
            }
            .padding()
        }
        .customBackgroundColor(colorScheme: colorScheme)
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
        
        FoodView()
            .preferredColorScheme(.dark)
    }
}
