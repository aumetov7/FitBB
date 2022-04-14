//
//  ExercisesView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct ExercisesView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0 ..< Exercise.exercises.count, id: \.self) { index in
                VStack {
                    ExerciseDetailView(index: index, selectedTab: $selectedTab)
                        .tag(index)
                    Spacer()
                    Text("Video")
                    Spacer()
                    Text("Start button")
                    Text("Raiting")
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))   
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}
