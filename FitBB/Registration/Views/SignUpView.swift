//
//  NewSignUpView.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @StateObject private var regViewModel = RegistrationViewModelImpl(
        service: RegistrationServiceImpl()
    )

    @State private var showPassword = false
    @State private var showRepeatPassword = false
    @State private var showPasswordDetails = false
    @State private var error = false
    @State private var passwordError = false
    
    @Binding var showSignUpView: Bool
    
    let emptyText = "Password must not be empty"
    let lowercaseText = "Password must have at least a 1 lowercase letter"
    let lengthText = "Password must be longer than 8 characters"
    let digitText = "Password must have at least a 1 digit"
    let uppercaseText = "Password must have at least a 1 uppercase letter"
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                signUpText
                    .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    emailTextField
                    
                    passwordTextField
                    
                    repeatPasswordView
                    
                    check()
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    signUpButton
                        
                    signIn
                }
                .padding(.horizontal)
            }
            .customBackgroundColor(colorScheme: colorScheme)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    func checkView(password: String, checkFunction: (String) -> Bool, text: String) -> some View {
        let checkMarkCircle = checkFunction(password) ? "checkmark.circle.fill" : "checkmark.circle"
        let checkImage = Image(systemName: checkMarkCircle).foregroundColor(checkFunction(password) ? .green : color)
        
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
                    .textField()
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal)
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func showPasswordTextField(showPassword: Bool, text: Binding<String>) -> some View {
        if !showPassword {
            SecureField("", text: text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textContentType(.password)
        } else {
            TextField("", text: text)
                .textField()
                .textContentType(.password)
        }
    }
    
    @ViewBuilder
    func showPasswordButton(showPassword: Bool) -> some View {
        if !showPassword {
            Image(systemName: "eye.slash")
                .foregroundColor(color)
        } else {
            Image(systemName: "eye")
                .foregroundColor(color)
        }
    }
    
    var passwordTextField: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .signText()
                .padding(.leading)
            
            HStack {
                showPasswordTextField(showPassword: showPassword, text: $regViewModel.userDetails.password)
                
                Button(action: {
                    withAnimation {
                        showPasswordDetails.toggle()
                    }
                }) {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(color)
                }
                .padding(.trailing, 2)
                
                Button(action: { showPassword.toggle() }) {
                    showPasswordButton(showPassword: showPassword)
                }
            }
            .padding(.horizontal)
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
                .padding(.horizontal)
        }
    }
    
    var repeatPasswordView: some View {
        VStack(alignment: .leading) {
            Text("Repeat password")
                .signText()
                .padding(.leading)
            
            HStack {
                showPasswordTextField(showPassword: showRepeatPassword, text: $regViewModel.userDetails.repeatPassword)
                
                Button(action: { showRepeatPassword.toggle() }) {
                    showPasswordButton(showPassword: showRepeatPassword)
                }
            }
            .padding(.horizontal)
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func check() -> some View {
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
            .foregroundColor(color)
            .opacity(0.9)
        } else {
            Spacer()
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
        .padding(.horizontal)
        .padding(.bottom, 45)
        .disabled(passwordValidation(text: regViewModel.userDetails.password) ? false : true)
        .foregroundColor(passwordValidation(text: regViewModel.userDetails.password) ? color : .gray)
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
    }
    
    var signIn: some View {
        HStack(spacing: 3) {
            Text("Already have an Account?")
                .signText()
            
            Button(action: { showSignUpView.toggle() }) {
                Text("Sign In")
                    .underline()
                    .signText()
            }
        }
    }

}

struct SignUpCombineView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showSignUpView: .constant(false))
        
        SignUpView(showSignUpView: .constant(false))
            .preferredColorScheme(.dark)
    }
}
