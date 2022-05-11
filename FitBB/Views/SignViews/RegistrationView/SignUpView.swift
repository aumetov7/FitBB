//
//  PasswordValidateView.swift
//  FitBB
//
//  Created by Акбар Уметов on 18/4/22.
//


import SwiftUI

struct SignUpView: View {
    @State private var showPassword = false
    @State private var showRepeatPassword = false
    @State private var showPasswordDetails = false
    @State private var error = false
    @State private var passwordError = false
    
    @ObservedObject var regViewModel: RegistrationViewModelImpl
    
    @Binding var showSignUpDetailInfoView: Bool
    @Binding var showSignUpView: Bool
    
    let emptyText = "Password must not be empty"
    let lowercaseText = "Password must have at least a 1 lowercase letter"
    let lengthText = "Password must be longer than 8 characters"
    let digitText = "Password must have at least a 1 digit"
    let uppercaseText = "Password must have at least a 1 uppercase letter"
    
    @ViewBuilder
    func checkView(password: String, checkFunction: (String) -> Bool, text: String) -> some View {
        let checkMarkCircle = checkFunction(password) ? "checkmark.circle.fill" : "checkmark.circle"
        let checkImage = Image(systemName: checkMarkCircle).foregroundColor(checkFunction(password) ? .green : .black)
        
        let textView = checkFunction(password) ? Text(text).strikethrough() : Text(text)
        
        HStack {
            checkImage
                .font(.footnote)
            textView
                .font(.footnote)
                .fontWeight(.light)
        }
        .padding(.trailing)
    }
    
    var signUpText: some View {
        Text("SIGN UP")
            .titleText()
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .signText()
                .padding(.leading)
            
            HStack {
                TextField("", text: $regViewModel.userDetails.email)
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
                    SecureField("", text: $regViewModel.userDetails.password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textContentType(.password)
                } else {
                    TextField("", text: $regViewModel.userDetails.password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textContentType(.password)
                }
                
                Button(action: {
                    withAnimation {
                        showPasswordDetails.toggle()
                    }
                }) {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.black)
                }
                .padding(.trailing, 2)
                
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
    
    var repeatPasswordView: some View {
        VStack(alignment: .leading) {
            Text("Repeat password")
                .signText()
                .padding(.leading)
            
            HStack {
                if !showRepeatPassword {
                    SecureField("", text: $regViewModel.userDetails.repeatPassword)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textContentType(.password)
                } else {
                    TextField("", text: $regViewModel.userDetails.repeatPassword)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textContentType(.password)
                }
                
                Button(action: { showRepeatPassword.toggle() }) {
                    if !showRepeatPassword {
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
    
    var signUpButton: some View {
        RaisedButton(buttonText: "Sign Up", action: {
            if regViewModel.userDetails.password != regViewModel.userDetails.repeatPassword {
                regViewModel.hasError = true
                passwordError = true
            } else {
                regViewModel.register()
            }
        })
    }
    
    var signInButton: some View {
        HStack {
            Button(action: { showSignUpView.toggle() }) {
                Text("Sign In")
                    .underline()
                    .signText()
            }
        }
    }
    
    var body: some View {
//        ContainerView {
            VStack {
                Spacer()
                
                signUpText
                
                Spacer()
                
                VStack {
                    emailTextField
                    
                    passwordTextField
                    
                    repeatPasswordView
                    
                    if showPasswordDetails {
                        VStack(alignment: .leading, spacing: 10) {
                            checkView(password: regViewModel.userDetails.password,
                                      checkFunction: isPasswordEmpty,
                                      text: emptyText)
                            checkView(password: regViewModel.userDetails.password,
                                      checkFunction: isContainsLowercaseLetter,
                                      text: lowercaseText)
                            checkView(password: regViewModel.userDetails.password,
                                      checkFunction: isMoreThanEightChar,
                                      text: lengthText)
                            checkView(password: regViewModel.userDetails.password,
                                      checkFunction: isContainsDigit,
                                      text: digitText)
                            checkView(password: regViewModel.userDetails.password,
                                      checkFunction: isContainsUppercaseLetter,
                                      text: uppercaseText)
                        }
                        .transition(.move(edge: .bottom))
                        .foregroundColor(.black)
                        .opacity(0.9)
                    } else {
                        Spacer()
                    }
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                
                Spacer()
                
                VStack {
                    signUpButton
                    .padding(.horizontal)
                    .padding(.bottom, 45)
                    .disabled(passwordValidation(text: regViewModel.userDetails.password) ? false : true)
                    .foregroundColor(passwordValidation(text: regViewModel.userDetails.password) ? .black : .gray)
                    .alert(isPresented: $regViewModel.hasError,
                           content: {
                        if case .failed(let error) = regViewModel.state {
                            return Alert(title: Text("Error"),
                                         message: Text(error.localizedDescription))
                        } else if passwordError { // Should add an Alert for password && email
                            return Alert(title: Text("Password Error"),
                                         message: Text("Passwords shouldn't be different."))
                        } else {
                            return Alert(title: Text("Error"),
                                         message: Text("Something went wrong."))
                        }
                    })
                    
                    HStack(spacing: 3) {
                        Text("Already have an Account?")
                            .signText()
                        
                        signInButton
                    }
                }
            }
            .padding(.horizontal)
            .ignoresSafeArea(.keyboard)
//        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(regViewModel: RegistrationViewModelImpl(service: RegistrationServiceImpl()),
                   showSignUpDetailInfoView: .constant(false),
                   showSignUpView: .constant(false))
    }
}
