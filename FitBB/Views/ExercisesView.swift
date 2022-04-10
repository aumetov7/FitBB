//
//  ExercisesView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct ExercisesView: View {
    @Binding var currentModal: ToolbarModal?
    
    var body: some View {
        Text("Exercises")
            .modifier(FitBBToolbar(currentModal: $currentModal))
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(currentModal: .constant(.exercises))
    }
}
