//
//  SuccessView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct SuccessView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Achievements")
                    .titleText()
            }
            .padding()
        }
        .customBackgroundColor(colorScheme: colorScheme)
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
        
        SuccessView()
            .preferredColorScheme(.dark)
    }
}
