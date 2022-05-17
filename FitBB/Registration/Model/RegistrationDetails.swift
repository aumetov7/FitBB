//
//  RegistrationDetail.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import Foundation
import UIKit

struct RegistrationDetails {
    var email: String
    var password: String
    var repeatPassword: String // do i need it?
    var profileImage: String
    var firstName: String
    var dateOfBirth: Date?
    var gender: String
    var goal: String
    var days: String
}

extension RegistrationDetails {
    static var new: RegistrationDetails {
        RegistrationDetails(email: "",
                            password: "",
                            repeatPassword: "",
                            profileImage: "",
                            firstName: "",
                            dateOfBirth: Date(),
                            gender: "",
                            goal: "",
                            days: "")
    }
}
