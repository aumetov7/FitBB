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
        .success: ("Success", "star.fill")
    ]
    
    var body: some View {
        if let text = modalButton[modal]?.text,
           let imageName = modalButton[modal]?.imageName {
            VStack {
                Image(systemName: imageName)
                    .font(.title)
                    .frame(minWidth: 50, minHeight: 50)
                Text(text)
                    .font(.caption2)
                    .fontWeight(.light)
            }
            .frame(minWidth: 50)
            .foregroundColor(.black)
            .padding(.bottom)
        }
    }
}

struct FitBBBottomToolbar: View {
    @Binding var toolbarModal: ToolbarModal?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: geometry.size.width * 0.07) {
                Button(action: { toolbarModal = .profile }) {
                    ToolbarButtonView(modal: .profile)
                }
                .frame(width: geometry.size.width * 0.15)
                
                
                Button(action: { toolbarModal = .exercises }) {
                    ToolbarButtonView(modal: .exercises)
                }
                .frame(width: geometry.size.width * 0.15)
                
                
                Button(action: { toolbarModal = .food }) {
                    ToolbarButtonView(modal: .food)
                }
                .frame(width: geometry.size.width * 0.15)
                
                
                Button(action: { toolbarModal = .history }) {
                    ToolbarButtonView(modal: .history)
                }
                .frame(width: geometry.size.width * 0.15)
                
                
                Button(action: { toolbarModal = .success }) {
                    ToolbarButtonView(modal: .success)
                }
                .frame(width: geometry.size.width * 0.15)
                
            }
            .frame(width: geometry.size.width)
        }
        .frame(minHeight: 100)
        .padding(.bottom)
    }
}

struct FitBBBottomToolbar_Previews: PreviewProvider {
    static var previews: some View {
        FitBBBottomToolbar(toolbarModal: .constant(.exercises))
        //            .previewLayout(.sizeThatFits)
            .padding()
    }
}
