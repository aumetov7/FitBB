//
//  NewSignIn.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct SignInCombineView: View {
    @StateObject private var loginViewModel = LoginViewModelImpl(
        service: LoginServiceImpl()
    )
    
    @StateObject private var forgotPasswordViewModel = ForgotPasswordViewModelImpl(
        service: ForgotPasswordServiceImpl()
    )
    
    @State private var showForgetPasswordView = false
    
    @Binding var showSignUpView: Bool
    
    var body: some View {
        SignInView(loginViewModel: loginViewModel,
               showSignUpView: $showSignUpView,
               showForgetPasswordView: $showForgetPasswordView)
            .sheet(isPresented: $showForgetPasswordView) {
                ForgetPasswordView(forgotPasswordViewModel: forgotPasswordViewModel,
                               showForgetPasswordView: $showForgetPasswordView)
            }
    }
}

struct SignInCombineView_Previews: PreviewProvider {
    static var previews: some View {
        SignInCombineView(showSignUpView: .constant(false))
    }
}
