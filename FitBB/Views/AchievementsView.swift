//
//  AchievementsView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct AchievementsView: View {
    @Binding var currentModal: ToolbarModal?
    
    var body: some View {
        Text("Achievements")
            .modifier(FitBBToolbar(currentModal: $currentModal))
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(currentModal: .constant(.achievements))
    }
}
