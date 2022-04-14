//
//  ExerciseDetailView.swift
//  FitBB
//
//  Created by Акбар Уметов on 12/4/22.
//

import SwiftUI

struct ExerciseDetailView: View {
    var index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            HeaderView(selectedTab: $selectedTab, titleText: Exercise.exercises[index].exerciseName)
            Text("\(index)")
        }
    }
}

struct ExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailView(index: 0, selectedTab: .constant(0))
    }
}
