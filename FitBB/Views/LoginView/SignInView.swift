//
//  SignInView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var loginViewModel = LoginViewModelImpl(
        service: LoginServiceImpl()
    )
    
    @StateObject private var forgotPasswordViewModel = ForgotPasswordViewModelImpl(
        service: ForgotPasswordServiceImpl()
    )
    
    @Binding var index: Int
    @Binding var showForgetPasswordView: Bool
    
    var body: some View {
        ZStack {
            if !showForgetPasswordView {
                SignInViewPage(loginViewModel: loginViewModel, index: $index,
                               showForgetPasswordView: $showForgetPasswordView)
            } else {
                ForgetPasswordView(index: $index,
                                   showForgetPasswordView: $showForgetPasswordView,
                                   forgotPasswordViewModel: forgotPasswordViewModel)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(index: .constant(0), showForgetPasswordView: .constant(false))
            .environmentObject(LoginViewModelImpl(service: LoginServiceImpl()))
            .environmentObject(ForgotPasswordViewModelImpl(service: ForgotPasswordServiceImpl()))
    }
}
