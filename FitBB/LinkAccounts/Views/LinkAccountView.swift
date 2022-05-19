//
//  LinkAccountView.swift
//  FitBB
//
//  Created by Акбар Уметов on 7/5/22.
//

import SwiftUI
import GoogleSignIn

struct LinkAccountView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @StateObject private var linkAccountViewModel = LinkAccountViewModelImpl(
        service: LinkAccountServiceImpl()
    )
    
    @State private var showEmailPasswordLinkView = false
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        GeometryReader { geometry in
            LazyVStack(alignment:.leading) {
                HStack(spacing: geometry.size.width * 0.10) {
                    Button {
                        linkAccountViewModel.linkGoogleAccount()
                    } label: {
                        HStack(spacing: 5) {
                            Image("google-plus")
                                .resizedToFill(width: 38, height: 38)
                            
                            Text("Google Sign In")
                                .makeRound()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: geometry.size.height * 0.05)
                        .padding(.leading)
                    }
                    .buttonStyle(RaisedButtonStyle())
                    .disabled(sessionService.getProviderId().contains("google.com") ? true : false)
                    .foregroundColor(sessionService.getProviderId().contains("google.com") ? .gray : color)
                    .frame(width: geometry.size.width * 0.5)
                    .padding(.all)
                    
                    if sessionService.getProviderId().contains("google.com") {
                        linkedText
                    }
                }
                
                HStack(spacing: geometry.size.width * 0.10) {
                    Button {
                        showEmailPasswordLinkView.toggle()
                    } label: {
                        HStack(spacing: 5) {
//                            Image("email")
                            Image(systemName: "envelope.circle.fill")
                                .resizedToFill(width: 32, height: 32)
                                .foregroundColor(color)
                            
                            Text("Email/Password")
                                .makeRound()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: geometry.size.height * 0.05)
                        .padding(.leading)
                    }
                    .buttonStyle(RaisedButtonStyle())
                    .disabled(sessionService.getProviderId().contains("password") ? true : false)
                    .foregroundColor(sessionService.getProviderId().contains("password") ? .gray : color)
                    .frame(width: geometry.size.width * 0.5)
                    .padding(.all)
                    
                    if sessionService.getProviderId().contains("password") {
                        linkedText
                    }
                }
            }
            .padding(.all)
            .navigationTitle("Link Accounts")
        }
        .customBackgroundColor(colorScheme: colorScheme)
        .sheet(isPresented: $showEmailPasswordLinkView) {
            EmailPasswordLinkView(linkAccountViewModel: linkAccountViewModel,
                                  showEmailPasswordLinkView: $showEmailPasswordLinkView)
        }
    }
    
    var linkedText: some View {
        HStack {
            Image(systemName: "checkmark.circle")
                .font(.title2)
            
            Text("Linked")
                .raisedButtonTextStyle()
        }
        .foregroundColor(.green)
    }
}

struct LinkAccountView_Previews: PreviewProvider {
    static var previews: some View {
        LinkAccountView()
            .environmentObject(SessionServiceImpl())
        
        LinkAccountView()
            .environmentObject(SessionServiceImpl())
            .preferredColorScheme(.dark)
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
