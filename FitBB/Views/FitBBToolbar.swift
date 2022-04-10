//
//  FitBBToolbar.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct FitBBToolbar: ViewModifier {
    @Binding var currentModal: ToolbarModal?
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    FitBBBottomToolbar(toolbarModal: $currentModal)
                }
            }
    }
}
