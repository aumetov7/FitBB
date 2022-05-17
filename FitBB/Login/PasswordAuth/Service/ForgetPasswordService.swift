//
//  ForgetPasswordServise.swift
//  FitBB
//
//  Created by Акбар Уметов on 15/4/22.
//

import Foundation
import Combine
import FirebaseAuth

protocol ForgetPasswordService {
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error>
}

final class ForgetPasswordServiceImpl: ForgetPasswordService {
    func sendPasswordReset(to email: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .sendPasswordReset(withEmail: email) { error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
