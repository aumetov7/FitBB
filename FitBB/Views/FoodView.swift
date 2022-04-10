//
//  FoodView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct FoodView: View {
    @Binding var currentModal: ToolbarModal?
    
    var body: some View {
        Text("Food")
            .modifier(FitBBToolbar(currentModal: $currentModal))
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView(currentModal: .constant(.food))
    }
}
