//
//  SignIn.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI
import GoogleSignIn

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
                Spacer()
                
                signInText
                
                Spacer()
                
                VStack {
                    emailTextField
                    
                    passwordTextField
                    
                    forgetPasswordButton
                    
                    anonymousAuthButton
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    signInButton
                    
                    connectWithText
                        .padding(.horizontal)
                    
                    connectWithButtons
                    
                    signUp
                }
                .padding(.horizontal)
                
            }
            .customBackgroundColor(colorScheme: colorScheme)
            
        }
        .ignoresSafeArea(.keyboard)
    }
    
    var signInText: some View {
        Text("SIGN IN")
            .titleText()
            .padding(.horizontal)
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .signText()
                .padding(.leading)
            
            HStack {
                TextField("", text: $loginViewModel.credential.email)
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
    
    var passwordTextField: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .signText()
                .padding(.leading)
            
            HStack {
                if !showPassword {
                    SecureField("", text: $loginViewModel.credential.password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                } else {
                    TextField("", text: $loginViewModel.credential.password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                
                Button(action: { showPassword.toggle() }) {
                    if !showPassword {
                        Image(systemName: "eye.slash")
                            .foregroundColor(color)
                    } else {
                        Image(systemName: "eye")
                            .foregroundColor(color)
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
                .padding(.horizontal)
        }
    }
    
    var forgetPasswordButton: some View {
        HStack {
            Spacer(minLength: 0)
            
            Button(action: { showForgetPasswordView.toggle() }) {
                Text("Forget Password?")
                    .underline()
                    .signText()
                    .padding(.leading)
            }
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
    
    var anonymousAuthButton: some View {
        HStack {
            Spacer(minLength: 0)
            
            Button(action: { anonymousAuthViewModel.anonymousAuth() }) {
                Text("Anonymous Authentification")
                    .underline()
                    .signText()
                    .padding(.leading)
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
        .padding(.top, 2)
    }
    
    var signInButton: some View {
        RaisedButton(buttonText: "SIGN IN") {
            loginViewModel.login()
        }
        .padding(.horizontal)
        .padding(.bottom, 45)
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
                .frame(width: 120)
                .lineLimit(1)
            
            VStack {
                Divider()
                    .background(color)
            }
        }
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
            }
        }
        .padding(.bottom)
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
    }
}
