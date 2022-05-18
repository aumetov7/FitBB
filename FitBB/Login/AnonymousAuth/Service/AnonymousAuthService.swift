//
//  AnonymousAuthService.swift
//  FitBB
//
//  Created by Акбар Уметов on 18/5/22.
//

import Foundation
import Combine
import FirebaseAuth

protocol AnonymousAuthService {
    func anonymousAuth() -> AnyPublisher<Void, Error>
}

final class AnonymousAuthServiseImpl: AnonymousAuthService {
    func anonymousAuth() -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth().signInAnonymously { authResult, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
//                        guard let user = authResult?.user else { return }
//                        let isAnonymous = user.isAnonymous
//                        let uid = user.uid
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
