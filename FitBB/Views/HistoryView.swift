//
//  HistoryView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("History")
                    .titleText()
            }
            .padding()
        }
        .customBackgroundColor(colorScheme: colorScheme)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
        
        HistoryView()
            .preferredColorScheme(.dark)
    }
}
