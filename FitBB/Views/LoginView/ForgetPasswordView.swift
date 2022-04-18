//
//  ForgetPasswordView.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import SwiftUI

struct ForgetPasswordView: View {
    @Binding var index: Int
    @State private var email = ""
    @Binding var showForgetPasswordView: Bool
    
    @ObservedObject var forgotPasswordViewModel: ForgotPasswordViewModelImpl
    
    var signInText: some View {
        Button(action: {
            showForgetPasswordView.toggle()
            index = 0
        }) {
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
                
                TextField("Email Address", text: $forgotPasswordViewModel.email)
                    .keyboardType(.emailAddress)
            }
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 40)
    }
    
    var resetPasswordButton: some View {
        Button(action: {
            forgotPasswordViewModel.sendPasswordReset()
            showForgetPasswordView.toggle()
        }) {
            Text("Reset Password")
                .foregroundColor(.white)
                .fontWeight(.black)
                .padding(.vertical)
                .padding(.horizontal, 50)
                .background(Color("Color1"))
                .clipShape(Capsule())
                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
        }
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
                    .padding(.bottom, 140)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("background"))
            .clipShape(SignInCShape())
            .contentShape(SignInCShape())
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: -2)
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            resetPasswordButton
        }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView(index: .constant(0),
                           showForgetPasswordView: .constant(true),
                           forgotPasswordViewModel: ForgotPasswordViewModelImpl(service: ForgotPasswordServiceImpl()))
    }
}
