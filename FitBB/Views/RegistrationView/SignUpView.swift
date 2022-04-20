//
//  PasswordValidateView.swift
//  FitBB
//
//  Created by Акбар Уметов on 18/4/22.
//


import SwiftUI

enum ErrorCheck {
    case emailErorr, passwordError, both, other
}

struct SignUpView: View {
    @State private var showPassword = false
    @State private var showRepeatPassword = false
    @State private var showPasswordDetails = false
    @State private var error = false
    @State private var errorState: ErrorCheck = .other
    
    @ObservedObject var regViewModel: RegistrationViewModelImpl
    
    @Binding var showSignUpDetailInfoView: Bool
    @Binding var showSignUpView: Bool
    
    let emptyText = "Password must not be empty"
    let lowercaseText = "Password must have at least a 1 lowercase letter"
    let lengthText = "Password must be longer than 8 characters"
    let digitText = "Password must have at least a 1 digit"
    let uppercaseText = "Password must have at least a 1 uppercase letter"
    
    func isPasswordEmpty(text: String) -> Bool {
        return !text.isEmpty
    }
    
    func isMoreThanEightChar(text: String) -> Bool {
        let passwordFormat = ".{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@ ", passwordFormat)
        
        return passwordPredicate.evaluate(with: text)
    }
    
    func isContainsDigit(text: String) -> Bool {
        let passwordFormat = ".*[0-9]+.*"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@ ", passwordFormat)
        
        return passwordPredicate.evaluate(with: text)
    }
    
    func isContainsUppercaseLetter(text: String) -> Bool {
        let passwordFormat = ".*[A-Z]+.*"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@ ", passwordFormat)
        
        return passwordPredicate.evaluate(with: text)
    }
    
    func isContainsLowercaseLetter(text: String) -> Bool {
        let passwordFormat = ".*[a-z]+.*"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@ ", passwordFormat)
        
        return passwordPredicate.evaluate(with: text)
    }
    
    func passwordValidation(text: String) -> Bool {
        let passwordFormat = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@ ", passwordFormat)
        
        return passwordPredicate.evaluate(with: text)
    }
    
    func emailValidation(text: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: text)
    }
    
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
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.black)
                .padding(.leading)
            
            HStack {
                if !showPassword {
                    SecureField("", text: $regViewModel.userDetails.password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                } else {
                    TextField("", text: $regViewModel.userDetails.password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
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
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.black)
                .padding(.leading)
            
            HStack {
                if !showRepeatPassword {
                    SecureField("", text: $regViewModel.userDetails.repeatPassword)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                } else {
                    TextField("", text: $regViewModel.userDetails.repeatPassword)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
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
    
    var signInButton: some View {
        HStack {
            Button(action: { showSignUpView.toggle() }) {
                Text("Sign In")
                    .underline()
                    .fontWeight(.light)
                    .font(.system(.callout))
                    .foregroundColor(.black)
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
                    RaisedButton(buttonText: "Continue", action: {
                        if regViewModel.userDetails.password != regViewModel.userDetails.repeatPassword &&
                            !emailValidation(text: regViewModel.userDetails.email) {
                            error = true
                            errorState = .both
                        } else if !emailValidation(text: regViewModel.userDetails.email) {
                            error = true
                            errorState = .emailErorr
                        } else if regViewModel.userDetails.password != regViewModel.userDetails.repeatPassword {
                            error = true
                            errorState = .passwordError
                        } else if regViewModel.userDetails.password == regViewModel.userDetails.repeatPassword &&
                                    emailValidation(text: regViewModel.userDetails.email) {
                            showSignUpDetailInfoView.toggle()
                        }
                    })
                    .padding(.horizontal)
                    .padding(.bottom, 45)
                    .disabled(passwordValidation(text: regViewModel.userDetails.password) ? false : true)
                    .foregroundColor(passwordValidation(text: regViewModel.userDetails.password) ? .black : .gray)
                    .alert(isPresented: $error) {
                        switch errorState {
                        case .emailErorr:
                            return Alert(title: Text("Email Error"),
                                         message: Text("Wrong email"))
                        case .passwordError:
                            return Alert(title: Text("Password Error"),
                                         message: Text("Passwords shouldn't be different"))
                        case .both:
                            return Alert(title: Text("Password and Email Error"),
                                         message: Text("Passwords shouldn't be different / Wrong email"))
                        case .other:
                            return Alert(title: Text("Error"),
                                         message: Text("Something went wrong"))
                        }
                    }
                    
                    HStack(spacing: 3) {
                        Text("Dont have an Account?")
                            .fontWeight(.light)
                            .font(.system(.callout))
                            .foregroundColor(.black)
                        
                        signInButton
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(regViewModel: RegistrationViewModelImpl(service: RegistrationServiceImpl()),
                   showSignUpDetailInfoView: .constant(false),
                   showSignUpView: .constant(false))
    }
}

