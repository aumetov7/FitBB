//
//  PasswordValidationViewExtension.swift
//  FitBB
//
//  Created by Акбар Уметов on 26/4/22.
//

import SwiftUI

extension View {
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
}
