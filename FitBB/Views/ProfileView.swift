//
//  ProfileView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct ProfileView: View {
    @State private var currentModal: ToolbarModal?
    
    var body: some View {
        switch currentModal {
        case .exercises:
            ExercisesView(currentModal: $currentModal)
            
        case .food:
            FoodView(currentModal: $currentModal)
            
        case .history:
            HistoryView(currentModal: $currentModal)
            
        case .achievements:
            AchievementsView(currentModal: $currentModal)
            
        default:
            Text("Welcome!")
                .modifier(FitBBToolbar(currentModal: $currentModal))
            
        }
        
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
