//
//  EmailPasswordLinkView.swift
//  FitBB
//
//  Created by Акбар Уметов on 18/5/22.
//

import SwiftUI

struct EmailPasswordLinkView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
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
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                signUpText
                    .frame(height: geometry.size.height / 5)
                
                VStack {
                    emailTextField
                    
                    passwordTextField
                    
                    repeatPasswordView
                }
                .frame(height: geometry.size.height / 3.5, alignment: .bottom)
                
                VStack {
                    check()
                }
                .frame(height: geometry.size.height / 6, alignment: .top)
                
                signUpButton
                    .frame(height: geometry.size.height / 7, alignment: .bottom)
            }
            .frame(height: geometry.size.height)
            .padding(.horizontal)
        }
        .ignoresSafeArea(.keyboard)
        .customBackgroundColor(colorScheme: colorScheme)
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
    }
    
    var signUpText: some View {
        Text("SIGN UP")
            .titleText()
    }
    
    var emailTextField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .signText()
            
            HStack {
                TextField("", text: $linkAccountViewModel.userDetails.email)
                    .textField()
                    .keyboardType(.emailAddress)
            }
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func showPasswordTextField(showPassword: Bool, text: Binding<String>) -> some View {
        if !showPassword {
            SecureField("", text: text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textContentType(.newPassword)
        } else {
            TextField("", text: text)
                .textField()
                .textContentType(.newPassword)
        }
    }
    
    @ViewBuilder
    func showPasswordButton(showPassword: Bool) -> some View {
        Image(systemName: !showPassword ? "eye.slash" : "eye")
            .foregroundColor(color)
    }
    
    var passwordTextField: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .signText()
            
            HStack {
                showPasswordTextField(showPassword: showPassword, text: $linkAccountViewModel.userDetails.password)
                
                Button {
                    withAnimation {
                        showPasswordDetails.toggle()
                    }
                } label: {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(color)
                }
                
                Button(action: { showPassword.toggle() }) {
                    showPasswordButton(showPassword: showPassword)
                }
            }
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
        }
        .padding(.horizontal)
    }
    
    var repeatPasswordView: some View {
        VStack(alignment: .leading) {
            Text("Repeat password")
                .signText()
            
            HStack {
                showPasswordTextField(showPassword: showRepeatPassword, text: $linkAccountViewModel.userDetails.repeatPassword)
                
                Button(action: { showRepeatPassword.toggle() }) {
                    showPasswordButton(showPassword: showRepeatPassword)
                }
            }
            
            Divider()
                .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
        }
        .padding(.horizontal)
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
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            .foregroundColor(.black)
            .opacity(0.9)
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
        .disabled(passwordValidation(text: linkAccountViewModel.userDetails.password) ? false : true)
        .foregroundColor(passwordValidation(text: linkAccountViewModel.userDetails.password) ? color : .gray)
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
                              showEmailPasswordLinkView: .constant(true))
        
        EmailPasswordLinkView(linkAccountViewModel: LinkAccountViewModelImpl(
            service: LinkAccountServiceImpl()),
                              showEmailPasswordLinkView: .constant(true))
        .preferredColorScheme(.dark)
    }
}
