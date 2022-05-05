//
//  GoogleSignInServicec.swift
//  FitBB
//
//  Created by Акбар Уметов on 28/4/22.
//

import Foundation
import GoogleSignIn
import Firebase
import Combine
import UIKit

protocol GoogleSignInService {
    func signIn() -> AnyPublisher<Void, Error>
}

class GoogleSignInServiceImpl: GoogleSignInService {
    private var signInConfig = GIDConfiguration.init(clientID: clientId)
    
    func signIn() -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
                
                GIDSignIn.sharedInstance.signIn(with: self.signInConfig, presenting: presentingViewController) { user, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        guard let authentification = user?.authentication, let idToken = authentification.idToken else { return }
                        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                       accessToken: authentification.accessToken)
                        
                        Auth
                            .auth()
                            .signIn(with: credential) { authResult, error in
                                if let error = error {
                                    promise(.failure(error))
                                } else {
                                    promise(.success(()))
                                }
                            }
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
