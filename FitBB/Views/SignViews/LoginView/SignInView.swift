//
//  SignIn.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI
import GoogleSignIn

struct SignInView: View {
    @State private var showPassword = false
    
    @ObservedObject var loginViewModel: LoginViewModelImpl
    @ObservedObject var googleSignInViewModel: GoogleSignInViewModelImpl
    
    @Binding var showSignUpView: Bool
    @Binding var showForgetPasswordView: Bool
    
    var signInText: some View {
        Text("SIGN IN")
            .titleText()
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
                            .foregroundColor(.black)
                    } else {
                        Image(systemName: "eye")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
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
    
    var signUpButton: some View {
        HStack {
            Button(action: { showSignUpView.toggle() }) {
                Text("Sign Up")
                    .underline()
                    .signText()
            }
        }
    }
    
    var body: some View {
//        ContainerView {
            VStack {
                Spacer()
                
                signInText
                
                Spacer()
                
                VStack {
                    emailTextField
                    
                    passwordTextField
                    
                    forgetPasswordButton
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                
                Spacer()
                
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
                
                HStack(spacing: 5) {
                    VStack {
                        Divider()
                            .background(Color.black)
                    }
                    
                    Text("Or Connect with")
                        .signText()
                        .frame(width: 120)
                        .lineLimit(1)
                    
                    VStack {
                        Divider()
                            .background(Color.black)
                    }
                }
                .padding(.horizontal)
                
                HStack(alignment: .bottom, spacing: 50) {
                    //                    Button(action: { }, label: {
                    //                        Image("apple-logo")
                    //                            .resizedToFill(width: 38, height: 38)
                    //                    })
                    
                    Button(action: {
                        googleSignInViewModel.signIn()
                    }, label: {
                        Image("google-plus")
                            .resizedToFill(width: 38, height: 38)
                    })
                }
                //                .padding(.horizontal)
                //                .frame(width: 155, height: 46)
                
                HStack(spacing: 3) {
                    Text("Dont have an Account?")
                        .signText()
                    
                    signUpButton
                }
            }
            .padding(.horizontal)
            .ignoresSafeArea(.keyboard)
//        }  
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(loginViewModel: LoginViewModelImpl(service: LoginServiceImpl()),
                   googleSignInViewModel: GoogleSignInViewModelImpl(service: GoogleSignInServiceImpl()),
                   showSignUpView: .constant(false),
                   showForgetPasswordView: .constant(false))
    }
}
