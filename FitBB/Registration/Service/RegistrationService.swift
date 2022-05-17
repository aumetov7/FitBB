//
//  RegistrationService.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import Combine
import Foundation
import Firebase
import FirebaseDatabase
//import UIKit
//import FirebaseStorage

enum RegistrationKeys: String {
    case profileImage, firstName, dateOfBirth, gender, goal, days
}

protocol RegistrationService {
    func register(with accountDetails: RegistrationDetails, with medicalDetails: MedicalDetails) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    func register(with accountDetails: RegistrationDetails, with medicalDetails: MedicalDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .createUser(withEmail: accountDetails.email,
                                password: accountDetails.password) { res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
                                 let accountValues = [RegistrationKeys.profileImage.rawValue: accountDetails.profileImage,
                                                     RegistrationKeys.firstName.rawValue: accountDetails.firstName,
                                                     RegistrationKeys.dateOfBirth.rawValue: "",
                                                     RegistrationKeys.gender.rawValue: accountDetails.gender,
                                                     RegistrationKeys.goal.rawValue: accountDetails.goal,
                                                     RegistrationKeys.days.rawValue: accountDetails.days] as [String : Any]
                                
//                                let medicalValues = [MedicalInfoKeys.weight.rawValue: medicalDetails.weight,
//                                                     MedicalInfoKeys.height.rawValue: medicalDetails.height,
//                                                     MedicalInfoKeys.bloodPressure.rawValue: medicalDetails.bloodPressure,
//                                                     MedicalInfoKeys.eyes.rawValue: medicalDetails.eyes,
//                                                     MedicalInfoKeys.spine.rawValue: medicalDetails.spine,
//                                                     MedicalInfoKeys.spinePartSelectedIndex.rawValue: medicalDetails.spinePartSelectedIndex,
//                                                     MedicalInfoKeys.heartSelectedIndex.rawValue: medicalDetails.heartSelectedIndex,
//                                                     MedicalInfoKeys.jointsAndLigamentsSelectedIndex.rawValue: medicalDetails.jointsAndLigamentsSelectedIndex] as [String: Any]
                                
                                Database
                                    .database()
                                    .reference()
                                    .child("users")
                                    .child(uid)
                                    .child("accountDetails")
                                    .updateChildValues(accountValues) { error, ref in
                                        if let err = error {
                                            promise(.failure(err))
                                        } else {
                                            promise(.success(()))
                                        }
                                    }
                                
//                                Database
//                                    .database()
//                                    .reference()
//                                    .child("users")
//                                    .child(uid)
//                                    .child("medicalDetails")
//                                    .updateChildValues(medicalValues) { error, ref in
//                                        if let err = error {
//                                            promise(.failure(err))
//                                        } else {
//                                            promise(.success(()))
//                                        }
//                                    }
                            } else {
                                promise(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
                            }
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
