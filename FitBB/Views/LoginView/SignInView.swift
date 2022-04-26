//
//  SignIn.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct SignInView: View {
    @State private var showPassword = false
    
    @ObservedObject var loginViewModel: LoginViewModelImpl
    
    @Binding var showSignUpView: Bool
    @Binding var showForgetPasswordView: Bool
    
    var signInText: some View {
        Text("SIGN IN")
            .font(.largeTitle)
            .fontWeight(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
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
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("background"))
                .edgesIgnoringSafeArea(.all)
            
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
                
                RaisedButton(buttonText: "Sign In") {
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
                
                HStack(spacing: 3) {
                    Text("Dont have an Account?")
                        .signText()
                    
                    signUpButton
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(loginViewModel: LoginViewModelImpl(service: LoginServiceImpl()),
               showSignUpView: .constant(false),
               showForgetPasswordView: .constant(false))
    }
}
