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
    
    @StateObject private var forgetPasswordViewModel = ForgetPasswordViewModelImpl(
        service: ForgetPasswordServiceImpl()
    )
    
    @StateObject private var googleSignInViewModel = GoogleSignInViewModelImpl(
        service: GoogleSignInServiceImpl()
    )
    
    @StateObject private var anonymousAuthViewModel = AnonymousAuthViewModelImpl(
        service: AnonymousAuthServiseImpl()
    )
    
    @State private var showForgetPasswordView = false
    
    @Binding var showSignUpView: Bool
    
    var body: some View {
        SignInView(loginViewModel: loginViewModel,
                   googleSignInViewModel: googleSignInViewModel,
                   anonymousAuthViewModel: anonymousAuthViewModel,
                   showSignUpView: $showSignUpView,
                   showForgetPasswordView: $showForgetPasswordView)
        .sheet(isPresented: $showForgetPasswordView) {
            ForgetPasswordView(forgetPasswordViewModel: forgetPasswordViewModel,
                               showForgetPasswordView: $showForgetPasswordView)
        }
    }
}

struct SignInCombineView_Previews: PreviewProvider {
    static var previews: some View {
        SignInCombineView(showSignUpView: .constant(false))
        
        SignInCombineView(showSignUpView: .constant(false))
            .preferredColorScheme(.dark)
    }
}
