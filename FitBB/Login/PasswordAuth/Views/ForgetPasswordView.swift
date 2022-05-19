//
//  ForgetPassword.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct ForgetPasswordView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var forgetPasswordViewModel: ForgetPasswordViewModelImpl
    
    @Binding var showForgetPasswordView: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                forgetPasswordText
                
                Spacer()
                
                VStack {
                    emailTextField
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                .padding(.horizontal)
                
                Spacer()
                
                resetPasswordButton
                    .padding(.horizontal)
                    .padding(.bottom, 65)
            }
            .customBackgroundColor(colorScheme: colorScheme)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    var forgetPasswordText: some View {
        Text("PASSWORD")
            .titleText()
            .padding(.horizontal)
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .signText()
                .padding(.leading)
            
            HStack {
                TextField("", text: $forgetPasswordViewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal)
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
                .padding(.horizontal)
        }
        
    }
    
    var resetPasswordButton: some View {
        RaisedButton(buttonText: "Reset password") {
            forgetPasswordViewModel.sendPasswordReset()
            showForgetPasswordView.toggle()
        }
        .padding(.horizontal)
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView(forgetPasswordViewModel: ForgetPasswordViewModelImpl(
                            service: ForgetPasswordServiceImpl()),
                           showForgetPasswordView: .constant(true))
        
        ForgetPasswordView(forgetPasswordViewModel: ForgetPasswordViewModelImpl(
                            service: ForgetPasswordServiceImpl()),
                           showForgetPasswordView: .constant(true))
        .preferredColorScheme(.dark)
    }
}
