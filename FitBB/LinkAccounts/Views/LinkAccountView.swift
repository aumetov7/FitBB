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
    
    @State private var showEmailPasswordLinkView = false
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    //    init() {
    //        UITableView.appearance().backgroundColor = .clear
    //        UITableViewCell.appearance().backgroundColor = .clear
    //    }
    
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
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    }
                    .buttonStyle(RaisedButtonStyle())
                    .disabled(sessionService.getProviderId().contains("google.com") ? true : false)
                    .foregroundColor(sessionService.getProviderId().contains("google.com") ? .gray : .black)
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
                            //                        Image(systemName: "envelope.circle.fill")
                            Image("email")
                                .resizedToFill(width: 38, height: 38)
                            
                            Text("Email/Password")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    }
                    .buttonStyle(RaisedButtonStyle())
                    .disabled(sessionService.getProviderId().contains("password") ? true : false)
                    .foregroundColor(sessionService.getProviderId().contains("password") ? .gray : .black)
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
