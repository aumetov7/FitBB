//
//  LinkAccountView.swift
//  FitBB
//
//  Created by Акбар Уметов on 7/5/22.
//

import SwiftUI
import GoogleSignIn

struct LinkAccountView: View {
    @StateObject private var linkAccountViewModel = LinkAccountViewModelImpl(
        service: LinkAccountServiceImpl()
    )
    
    @Binding var showProfileMenu: Bool
    
    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.all)
            
            SignInButton()
                .onTapGesture {
                    linkAccountViewModel.linkGoogleAccount()
                    showProfileMenu.toggle()
                }
                .padding(.all)
        }
    }
}

struct LinkAccountView_Previews: PreviewProvider {
    static var previews: some View {
        LinkAccountView(showProfileMenu: .constant(true))
    }
}

struct SignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
    }
}
