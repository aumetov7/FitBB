//
//  LinkAccountServise.swift
//  FitBB
//
//  Created by Акбар Уметов on 7/5/22.
//

import Foundation
import GoogleSignIn
import Firebase
import Combine
import UIKit

protocol LinkAccountService {
    func linkGoogleAccount() -> AnyPublisher<Void, Error>
}

class LinkAccountServiceImpl: LinkAccountService {
    private var signInConfig = GIDConfiguration.init(clientID: clientId)
    
    func linkGoogleAccount() -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
                
                GIDSignIn.sharedInstance.signIn(with: self.signInConfig, presenting: presentingViewController) { user, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        guard let authentification = user?.authentication, let idToken = authentification.idToken else { return }
                        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentification.accessToken)
                        
                        Auth.auth().currentUser?.link(with: credential, completion: { authResult, error in
                            if let error = error {
                                promise(.failure(error))
                                print("Error: \(error.localizedDescription)")
                            } else {
                                promise(.success(()))
                            }
                        })
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
