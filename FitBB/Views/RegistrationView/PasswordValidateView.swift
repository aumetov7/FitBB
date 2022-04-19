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

struct PasswordValidateView: View {
    @State private var pswrd = ""
    @State private var rptPswrd = ""
    @State private var showPassword = false
    @State private var showDetails = false
    @State private var emailAccount = ""
    @State private var error = false
    @State private var errorState: ErrorCheck = .other
    
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

//    func emailValidation(_ text: String) -> Bool {
//        if text.count > 100 {
//            return false
//        }
//
//        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
//        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
//        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
//
//        return emailPredicate.evaluate(with: text)
//    }
    
    
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
    
    var emailID: some View {
        VStack(alignment: .leading) {
            Text("Email ID*")
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.gray)
                .padding(.leading)
            
            HStack {
                TextField("", text: $emailAccount)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    var pswrdView: some View {
        VStack(alignment: .leading) {
            Text("Password*")
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.gray)
                .padding(.leading)
            
            HStack {
                if !showPassword {
                    SecureField("", text: $pswrd)
                        .textInputAutocapitalization(.never)
                } else {
                    TextField("", text: $pswrd)
                        .textInputAutocapitalization(.never)
                }
                
                Button(action: {
                    withAnimation {
                        showDetails.toggle()
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
    
    var rptPswrdView: some View {
        VStack(alignment: .leading) {
            Text("Repeat password*")
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.gray)
                .padding(.leading)
            
            HStack {
                if !showPassword {
                    SecureField("", text: $rptPswrd)
                        .textInputAutocapitalization(.never)
                } else {
                    TextField("", text: $rptPswrd)
                        .textInputAutocapitalization(.never)
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
    
    var signUpText: some View {
        Text("SIGN UP")
            .font(.largeTitle)
            .fontWeight(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
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
                    emailID
                    
                    pswrdView
                    
                    rptPswrdView
                    
                    if showDetails {
                        VStack(alignment: .leading, spacing: 10) {
                            checkView(password: pswrd, checkFunction: isPasswordEmpty, text: emptyText)
                            checkView(password: pswrd, checkFunction: isContainsLowercaseLetter, text: lowercaseText)
                            checkView(password: pswrd, checkFunction: isMoreThanEightChar, text: lengthText)
                            checkView(password: pswrd, checkFunction: isContainsDigit, text: digitText)
                            checkView(password: pswrd, checkFunction: isContainsUppercaseLetter, text: uppercaseText)
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
                        if pswrd != rptPswrd && emailAccount.isEmpty {
                            error = true
                            errorState = .both
                        } else if emailAccount.isEmpty {
                            error = true
                            errorState = .emailErorr
                        } else if pswrd != rptPswrd {
                            error = true
                            errorState = .passwordError
                        }
                    })
                    .padding(.horizontal)
                    .padding(.bottom, 45)
                    .disabled(passwordValidation(text: pswrd) ? false : true)
                    .foregroundColor(passwordValidation(text: pswrd) ? .black : .gray)
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
                    
                }
                
            }
            .padding(.horizontal)
        }
    }
}

struct PasswordValidateView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordValidateView()
    }
}

