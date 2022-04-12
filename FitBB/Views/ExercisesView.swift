//
//  ExercisesView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct ExercisesView: View {
    var body: some View {
        TabView {
            ForEach(0 ..< Exercise.exercises.count, id: \.self) { index in
                Text("\(Exercise.exercises[index].exerciseName)")
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
