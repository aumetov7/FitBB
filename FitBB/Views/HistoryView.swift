//
//  HistoryView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct HistoryView: View {
    @Binding var currentModal: ToolbarModal?
    
    var body: some View {
        Text("History")
            .modifier(FitBBToolbar(currentModal: $currentModal))
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(currentModal: .constant(.history))
    }
}
