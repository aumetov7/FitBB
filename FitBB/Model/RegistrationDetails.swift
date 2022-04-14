//
//  RegistrationDetail.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import Foundation

struct RegistrationDetails {
    var email: String
    var password: String
    var repeatPassword: String // do i need it?
    var firstName: String
    var gender: String
    var goal: String
}

extension RegistrationDetails {
    static var new: RegistrationDetails {
        RegistrationDetails(email: "",
                            password: "",
                            repeatPassword: "",
                            firstName: "",
                            gender: "",
                            goal: "")
    }
}
