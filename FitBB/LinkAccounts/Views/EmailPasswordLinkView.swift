//
//  EmailPasswordLinkView.swift
//  FitBB
//
//  Created by Акбар Уметов on 18/5/22.
//

import SwiftUI

struct EmailPasswordLinkView: View {
    @State private var showPassword = false
    @State private var showRepeatPassword = false
    @State private var showPasswordDetails = false
    @State private var error = false
    @State private var passwordError = false
    
    @ObservedObject var linkAccountViewModel: LinkAccountViewModelImpl
    
    @Binding var showEmailPasswordLinkView: Bool
    
    let emptyText = "Password must not be empty"
    let lowercaseText = "Password must have at least a 1 lowercase letter"
    let lengthText = "Password must be longer than 8 characters"
    let digitText = "Password must have at least a 1 digit"
    let uppercaseText = "Password must have at least a 1 uppercase letter"
    
    var body: some View {
        VStack {
            Spacer()
            
            signUpText
            
            Spacer()
            
            VStack {
                emailTextField
                
                passwordTextField
                
                repeatPasswordView
                
                check()
            }
            .frame(height: 316, alignment: .center)
            .padding(.bottom, 25)
            
            Spacer()
            
            VStack {
                signUpButton
            }
        }
        .padding(.horizontal)
        .ignoresSafeArea(.keyboard)
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
            .titleText()
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .signText()
                .padding(.leading)
            
            HStack {
                TextField("", text: $linkAccountViewModel.userDetails.email)
                    .textField()
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal)
            
            Divider()
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
                .foregroundColor(.black)
        } else {
            Image(systemName: "eye")
                .foregroundColor(.black)
        }
    }
    
    var passwordTextField: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .signText()
                .padding(.leading)
            
            HStack {
                showPasswordTextField(showPassword: showPassword, text: $linkAccountViewModel.userDetails.password)
                
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
                    showPasswordButton(showPassword: showPassword)
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
                showPasswordTextField(showPassword: showRepeatPassword, text: $linkAccountViewModel.userDetails.repeatPassword)
                
                Button(action: { showRepeatPassword.toggle() }) {
                    showPasswordButton(showPassword: showRepeatPassword)
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func check() -> some View {
        if showPasswordDetails {
            VStack(alignment: .leading, spacing: 10) {
                checkView(password: linkAccountViewModel.userDetails.password,
                          checkFunction: isPasswordEmpty,
                          text: emptyText)
                checkView(password: linkAccountViewModel.userDetails.password,
                          checkFunction: isContainsLowercaseLetter,
                          text: lowercaseText)
                checkView(password: linkAccountViewModel.userDetails.password,
                          checkFunction: isMoreThanEightChar,
                          text: lengthText)
                checkView(password: linkAccountViewModel.userDetails.password,
                          checkFunction: isContainsDigit,
                          text: digitText)
                checkView(password: linkAccountViewModel.userDetails.password,
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
    
    var signUpButton: some View {
        RaisedButton(buttonText: "Link Accounts", action: {
            if linkAccountViewModel.userDetails.password != linkAccountViewModel.userDetails.repeatPassword {
                linkAccountViewModel.hasError = true
                passwordError = true
            } else {
                linkAccountViewModel.linkEmailPasswordAccount()
                showEmailPasswordLinkView.toggle()
            }
        })
        .padding(.horizontal)
        .padding(.bottom, 45)
        .disabled(passwordValidation(text: linkAccountViewModel.userDetails.password) ? false : true)
        .foregroundColor(passwordValidation(text: linkAccountViewModel.userDetails.password) ? .black : .gray)
        .alert(isPresented: $linkAccountViewModel.hasError,
               content: {
            if case .failed(let error) = linkAccountViewModel.state {
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
}

struct EmailPasswordLinkView_Previews: PreviewProvider {
    static var previews: some View {
        EmailPasswordLinkView(linkAccountViewModel: LinkAccountViewModelImpl(
            service: LinkAccountServiceImpl()),
                              showEmailPasswordLinkView: .constant(true)
        )
    }
}
