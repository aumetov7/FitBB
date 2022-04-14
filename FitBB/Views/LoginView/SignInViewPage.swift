//
//  SignInViewPage.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import SwiftUI

struct SignInViewPage: View {
    @ObservedObject var loginViewModel: LoginViewModelImpl
    
    @Binding var index: Int
    @Binding var showForgetPasswordView: Bool
    
    func check(email: String, password: String) -> Bool {
        if !email.isEmpty && !password.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    var signInText: some View {
        Button(action: { index = 0 }) {
            VStack(spacing: 10) {
                Text("Sign In")
                    .foregroundColor(index == 0 ? .black : .gray)
                    .font(.title)
                    .fontWeight(.black)
                
                Capsule()
                    .fill(index == 0 ? Color.black : Color.clear)
                    .frame(width: 100, height: 5)
            }
        }
    }
    
    var emailAddressTextField: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color("Color1"))
                
                TextField("Email Address", text: $loginViewModel.credential.email)
            }
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 40)
    }
    
    var passwordTextField: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "lock")
                    .foregroundColor(Color("Color1"))
                
                SecureField("Password", text: $loginViewModel.credential.password)
            }
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
    
    var forgetPasswordButton: some View {
        HStack {
            Spacer(minLength: 0)
            
            Button(action: { showForgetPasswordView.toggle() }) {
                Text("Forget Password?")
                    .foregroundColor(Color.black.opacity(0.6))
            }
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
    
    var signInButton: some View {
        Button(action: {
            loginViewModel.login()
        }) {
            Text("Sign In")
                .foregroundColor(.white)
                .fontWeight(.black)
                .padding(.vertical)
                .padding(.horizontal, 50)
//                .background(Color("Color1"))
                .background(check(email: loginViewModel.credential.email,
                                  password: loginViewModel.credential.password) ? Color("Color1") : Color.gray)
                .clipShape(Capsule())
                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .disabled(!check(email: loginViewModel.credential.email,
                         password: loginViewModel.credential.password))
        .offset(y: 25)
        .opacity(index == 0 ? 1 : 0)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    signInText

                    Spacer(minLength: 0)
                }
                .padding(.top, 30)
                
                emailAddressTextField
                
                passwordTextField
                
                forgetPasswordButton
                    .padding(.bottom, 20)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("background"))
            .clipShape(SignInCShape())
            .contentShape(SignInCShape())
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: -2)
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            signInButton
        }
    }
}

struct SignInCShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}
struct SignInViewPage_Previews: PreviewProvider {
    static var previews: some View {
        SignInViewPage(loginViewModel: LoginViewModelImpl(service: LoginServiceImpl()), index: .constant(0), showForgetPasswordView: .constant(false))
    }
}
