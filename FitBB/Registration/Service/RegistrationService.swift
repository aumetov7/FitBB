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

enum RegistrationKeys: String {
    case profileImage, firstName, dateOfBirth, gender, goal, days
}

protocol RegistrationService {
    func register(with accountDetails: RegistrationDetails) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: RegistrationService {
    func register(with accountDetails: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .createUser(withEmail: accountDetails.email,
                                password: accountDetails.password) { res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
//                            if let uid = res?.user.uid {
                                promise(.success(()))
//                        } else {
//                                promise(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
//                        }
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
