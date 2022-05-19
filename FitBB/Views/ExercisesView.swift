//
//  ExercisesView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct ExercisesView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0 ..< Exercise.exercises.count, id: \.self) { index in
                VStack {
                    ExerciseDetailView(selectedTab: $selectedTab, index: index)
                        .tag(index)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .customBackgroundColor(colorScheme: colorScheme)
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
        
        ExercisesView()
            .preferredColorScheme(.dark)
    }
}
