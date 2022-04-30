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
import UIKit
import FirebaseStorage

enum RegistrationKeys: String {
    case profileImage, firstName, dateOfBirth, gender, goal
}

protocol RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
    func updateAccountInfo(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth()
                    .createUser(withEmail: details.email,
                                password: details.password) { res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
                                
                                let values = [RegistrationKeys.profileImage.rawValue: "",
                                              RegistrationKeys.firstName.rawValue: details.firstName,
                                              RegistrationKeys.dateOfBirth.rawValue: "",
                                              RegistrationKeys.gender.rawValue: details.gender,
                                              RegistrationKeys.goal.rawValue: details.goal] as [String : Any]
                                
                                Database.database()
                                    .reference()
                                    .child("users")
                                    .child(uid)
                                    .updateChildValues(values) { error, ref in
                                        if let err = error {
                                            promise(.failure(err))
                                        } else {
                                            promise(.success(()))
                                        }
                                    }
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
    
    func updateAccountInfo(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                let values = [RegistrationKeys.profileImage.rawValue: "",
                              RegistrationKeys.firstName.rawValue: details.firstName,
                              RegistrationKeys.dateOfBirth.rawValue: dateFormatter.string(from: details.dateOfBirth!),
                              RegistrationKeys.gender.rawValue: details.gender,
                              RegistrationKeys.goal.rawValue: details.goal] as [String : Any]
                
                Database.database()
                    .reference().child("users").child(uid).updateChildValues(values) { error, ref in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}

