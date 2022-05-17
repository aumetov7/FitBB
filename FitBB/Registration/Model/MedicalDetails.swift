//
//  MedicalDetails.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/5/22.
//

import Foundation

struct MedicalDetails {
    var weight: String
    var height: String
    var bloodPressure: String
    var eyes: String
    var spine: String
    var spinePartSelectedIndex: Int
    var heartSelectedIndex: Int
    var jointsAndLigamentsSelectedIndex: Int
}

extension MedicalDetails {
    static var new: MedicalDetails {
        MedicalDetails(weight: "",
                       height: "",
                       bloodPressure: "",
                       eyes: "",
                       spine: "",
                       spinePartSelectedIndex: 0,
                       heartSelectedIndex: 0,
                       jointsAndLigamentsSelectedIndex: 0)
    }
}
