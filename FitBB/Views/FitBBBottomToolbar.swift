//
//  FitBBToolbar.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct ToolbarButtonView: View {
    let modal: ToolbarModal
    private let modalButton:
    [ToolbarModal: (text:String, imageName: String)] = [
        .profile: ("Profile", "person.fill"),
        .exercises: ("Exercises", "figure.walk"),
        .food: ("Food", "drop.fill"),
        .history: ("History", "clock.arrow.circlepath"),
        .achievements: ("Achievement", "star.fill")
    ]
    
    var body: some View {
        if let text = modalButton[modal]?.text,
           let imageName = modalButton[modal]?.imageName {
            VStack {
                Image(systemName: imageName)
                    .font(.title2)
                    .frame(height: 30)
                
                Text(text)
                    .font(.footnote)
            }
            .foregroundColor(.black)
            .padding(.top)
        }
    }
}

struct FitBBBottomToolbar: View {
    @Binding var toolbarModal: ToolbarModal?
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: { toolbarModal = .profile }) {
                ToolbarButtonView(modal: .profile)
            }
            
            
            Button(action: { toolbarModal = .exercises }) {
                ToolbarButtonView(modal: .exercises)
            }
            
            
            Button(action: { toolbarModal = .food }) {
                ToolbarButtonView(modal: .food)
            }
            
            
            Button(action: { toolbarModal = .history }) {
                ToolbarButtonView(modal: .history)
            }
            
            
            Button(action: { toolbarModal = .achievements }) {
                ToolbarButtonView(modal: .achievements)
            }
            
        }
    }
}

struct FitBBBottomToolbar_Previews: PreviewProvider {
    static var previews: some View {
        FitBBBottomToolbar(toolbarModal: .constant(.exercises))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
