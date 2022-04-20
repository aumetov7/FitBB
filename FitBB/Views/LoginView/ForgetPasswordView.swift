//
//  ForgetPassword.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct ForgetPasswordView: View {
    @ObservedObject var forgotPasswordViewModel: ForgotPasswordViewModelImpl
    
    @Binding var showForgetPasswordView: Bool
    
    var forgetPasswordText: some View {
        Text("PASSWORD")
            .font(.largeTitle)
            .fontWeight(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.black)
                .padding(.leading)
            
            HStack {
                TextField("", text: $forgotPasswordViewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("background"))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                forgetPasswordText
                
                Spacer()
                
                VStack {
                    emailTextField
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                
                Spacer()
                
                RaisedButton(buttonText: "Reset password") {
                    forgotPasswordViewModel.sendPasswordReset()
                    showForgetPasswordView.toggle()
                }
                .padding(.horizontal)
                .padding(.bottom, 65)
            }
            .padding(.horizontal)
        }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView(forgotPasswordViewModel: ForgotPasswordViewModelImpl(service: ForgotPasswordServiceImpl()),
                       showForgetPasswordView: .constant(true))
    }
}
