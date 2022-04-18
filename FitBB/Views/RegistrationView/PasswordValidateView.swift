//
//  PasswordValidateView.swift
//  FitBB
//
//  Created by Акбар Уметов on 18/4/22.
//

import SwiftUI

struct PasswordValidateView: View {
    @State private var pswrd = ""
    @State private var showPassword = false
    
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
    
    
    @ViewBuilder
    func checkView(password: String, checkFunction: (String) -> Bool, text: String) -> some View {
        let checkMarkCircle = checkFunction(password) ? "checkmark.circle.fill" : "checkmark.circle"
        let checkImage = Image(systemName: checkMarkCircle).foregroundColor(checkFunction(password) ? .green : .black)
        
        
        let textView = checkFunction(password) ? Text(text).strikethrough() : Text(text)
        
        HStack {
            checkImage
            textView
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                if !showPassword {
                    SecureField("Password", text: $pswrd)
                        .textInputAutocapitalization(.never)
                        .padding()
                } else {
                    TextField("Password", text: $pswrd)
                        .textInputAutocapitalization(.never)
                        .padding()
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
            
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    let text = "Password must not be empty"
                    checkView(password: pswrd, checkFunction: isPasswordEmpty, text: text)
                }
                
                HStack {
                    let text = "Password must have at least a 1 lowercase letter"
                    checkView(password: pswrd, checkFunction: isContainsLowercaseLetter, text: text)
                }
                
                HStack {
                    let text = "Password must be longer than 8 characters"
                    checkView(password: pswrd, checkFunction: isMoreThanEightChar, text: text)
                }
                
                HStack {
                    let text = "Password must have at least a 1 digit"
                    checkView(password: pswrd, checkFunction: isContainsDigit, text: text)
                }
                
                HStack {
                    let text = "Password must have at least a 1 uppercase letter"
                    checkView(password: pswrd, checkFunction: isContainsUppercaseLetter, text: text)
                }
            }
        
        }
        .background(Color("background"))
        .padding(.horizontal)
    }
}

struct PasswordValidateView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordValidateView()
    }
}

