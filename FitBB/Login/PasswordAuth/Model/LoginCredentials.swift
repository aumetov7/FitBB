//
//  LoginCredentials.swift
//  FitBB
//
//  Created by Акбар Уметов on 15/4/22.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
}

extension LoginCredentials {
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}
