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
                forgetPasswordText
                    .frame(height: geometry.size.height / 5, alignment: .top)
                
                emailTextField
                    .frame(height: geometry.size.height / 3.5)
                
                resetPasswordButton
                    .frame(height: geometry.size.height / 5, alignment: .bottom)
            }
            .frame(height: geometry.size.height)
            .padding(.horizontal)
        }
        .customBackgroundColor(colorScheme: colorScheme)
        .ignoresSafeArea(.keyboard)
    }
    
    var forgetPasswordText: some View {
        Text("PASSWORD")
            .titleText()
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .signText()
            
            HStack {
                TextField("", text: $forgetPasswordViewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
            }
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
        }
        .padding(.horizontal)
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
