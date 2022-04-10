//
//  SuccessView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct SuccessView: View {
    @Binding var currentModal: ToolbarModal?
    
    var body: some View {
        Text("Achievements")
            .modifier(FitBBToolbar(currentModal: $currentModal))
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(currentModal: .constant(.success))
    }
}
