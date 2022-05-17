//
//  UpdateProfileService.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/5/22.
//

import Foundation
import Combine
import Firebase
import FirebaseDatabase

protocol UpdateProfileService {
    func updateAccountInfo(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
}

final class UpdateProfileServiceImpl: UpdateProfileService {
    func updateAccountInfo(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                let values = [RegistrationKeys.profileImage.rawValue: details.profileImage,
                              RegistrationKeys.firstName.rawValue: details.firstName,
                              RegistrationKeys.dateOfBirth.rawValue: dateFormatter.string(from: details.dateOfBirth!),
                              RegistrationKeys.gender.rawValue: details.gender,
                              RegistrationKeys.goal.rawValue: details.goal,
                              RegistrationKeys.days.rawValue: details.days] as [String : Any]
                
                Database
                    .database()
                    .reference()
                    .child("users")
                    .child(uid)
                    .child("accountDetails")
                    .updateChildValues(values) { error, ref in
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
