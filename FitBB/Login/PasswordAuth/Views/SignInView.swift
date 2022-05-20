//
//  SignIn.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var showPassword = false
    
    @ObservedObject var loginViewModel: LoginViewModelImpl
    @ObservedObject var googleSignInViewModel: GoogleSignInViewModelImpl
    @ObservedObject var anonymousAuthViewModel: AnonymousAuthViewModelImpl
    
    @Binding var showSignUpView: Bool
    @Binding var showForgetPasswordView: Bool
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                signInText
                    .frame(height: geometry.size.height / 5)
                
                VStack {
                    emailTextField
                    passwordTextField
                }
                .frame(height: geometry.size.height / 3.5, alignment: .bottom)
                
                VStack(spacing: 10) {
                    forgetPasswordButton
                    anonymousAuthButton
                }
                .frame(height: geometry.size.height / 9, alignment: .top)
                
                signInButton
                    .frame(height: geometry.size.height / 6, alignment: .bottom)
                
                VStack(spacing: 10) {
                    connectWithText
                    connectWithButtons
                    signUp
                }
                .frame(height: geometry.size.height / 7, alignment: .bottom)
            }
            .frame(height: geometry.size.height)
            .padding(.horizontal)
        }
        .ignoresSafeArea(.keyboard)
        .customBackgroundColor(colorScheme: colorScheme)
    }
    
    var signInText: some View {
        Text("SIGN IN")
            .titleText()
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Email")
                .signText()
            
            HStack {
                TextField("", text: $loginViewModel.credential.email)
                    .textField()
                    .keyboardType(.emailAddress)
            }
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
        }
        .padding(.horizontal)
    }
    
    var passwordTextField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Password")
                .signText()
            
            HStack {
                if !showPassword {
                    SecureField("", text: $loginViewModel.credential.password)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                } else {
                    TextField("", text: $loginViewModel.credential.password)
                        .textField()
                        .textContentType(.password)
                }
                
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: !showPassword ? "eye.slash" : "eye")
                        .foregroundColor(color)
                }
            }
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
        }
        .padding(.horizontal)
    }
    
    var forgetPasswordButton: some View {
        HStack {
            Spacer(minLength: 0)
            
            Button(action: { showForgetPasswordView.toggle() }) {
                Text("Forget Password?")
                    .underline()
                    .signText()
                //                    .foregroundColor(color)
            }
        }
        .padding(.horizontal)
    }
    
    var anonymousAuthButton: some View {
        HStack {
            Spacer(minLength: 0)
            
            Button(action: { anonymousAuthViewModel.anonymousAuth() }) {
                Text("Anonymous Authentification")
                    .underline()
                    .signText()
                //                    .foregroundColor(color)
            }
            .alert(isPresented: $anonymousAuthViewModel.hasError,
                   content: {
                if case .failed(let error) = anonymousAuthViewModel.state {
                    return Alert(title: Text("Error"),
                                 message: Text(error.localizedDescription))
                } else {
                    return Alert(title: Text("Error"),
                                 message: Text("Something went wrong"))
                }
            })
        }
        .padding(.horizontal)
    }
    
    var signInButton: some View {
        RaisedButton(buttonText: "SIGN IN") {
            loginViewModel.login()
        }
        .padding(.horizontal)
        .alert(isPresented: $loginViewModel.hasError,
               content: {
            if case .failed(let error) = loginViewModel.state {
                return Alert(title: Text("Error"),
                             message: Text(error.localizedDescription))
            } else {
                return Alert(title: Text("Error"),
                             message: Text("Something went wrong"))
            }
        })
    }
    
    var connectWithText: some View {
        HStack(spacing: 5) {
            VStack {
                Divider()
                    .background(color)
            }
            
            Text("Or Connect with")
                .signText()
                .fixedSize()
            
            VStack {
                Divider()
                    .background(color)
            }
        }
        .padding(.horizontal)
    }
    
    var connectWithButtons: some View {
        HStack(alignment: .bottom, spacing: 20) {
            //                    Button(action: { }, label: {
            //                        Image("apple-logo")
            //                            .resizedToFill(width: 38, height: 38)
            //                    })
            
            //            Button(action: {
            //
            //            }) {
            //                Image("email")
            //                    .resizedToFill(width: 38, height: 38)
            //            }
            
            Button(action: {
                googleSignInViewModel.signIn()
            }, label: {
                Image("google-plus")
                    .resizedToFill(width: 38, height: 38)
            })
        }
    }
    
    var signUp: some View {
        HStack(spacing: 3) {
            Text("Dont have an Account?")
                .signText()
            
            Button(action: { showSignUpView.toggle() }) {
                Text("Sign Up")
                    .underline()
                    .signText()
                //                    .foregroundColor(color)
            }
        }
        //        .padding(.bottom)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(loginViewModel: LoginViewModelImpl(
            service: LoginServiceImpl()),
                   googleSignInViewModel: GoogleSignInViewModelImpl(
                    service: GoogleSignInServiceImpl()),
                   anonymousAuthViewModel: AnonymousAuthViewModelImpl(
                    service: AnonymousAuthServiseImpl()),
                   showSignUpView: .constant(false),
                   showForgetPasswordView: .constant(false))
        
        SignInView(loginViewModel: LoginViewModelImpl(
            service: LoginServiceImpl()),
                   googleSignInViewModel: GoogleSignInViewModelImpl(
                    service: GoogleSignInServiceImpl()),
                   anonymousAuthViewModel: AnonymousAuthViewModelImpl(
                    service: AnonymousAuthServiseImpl()),
                   showSignUpView: .constant(false),
                   showForgetPasswordView: .constant(false))
        .preferredColorScheme(.dark)
        
        SignInView(loginViewModel: LoginViewModelImpl(
            service: LoginServiceImpl()),
                   googleSignInViewModel: GoogleSignInViewModelImpl(
                    service: GoogleSignInServiceImpl()),
                   anonymousAuthViewModel: AnonymousAuthViewModelImpl(
                    service: AnonymousAuthServiseImpl()),
                   showSignUpView: .constant(false),
                   showForgetPasswordView: .constant(false))
        .previewDevice("iPhone 8")
    }
}
