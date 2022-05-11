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
    
    var body: some View {
//        ContainerView {
            VStack {
                Text("Link Accounts")
                    .titleText()
                    .padding(.top)
                
                SignInButton()
                    .onTapGesture {
                        linkAccountViewModel.linkGoogleAccount()
                    }
                    .padding(.all)
            }
//        }
    }
}

struct LinkAccountView_Previews: PreviewProvider {
    static var previews: some View {
        LinkAccountView()
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
