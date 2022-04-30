//
//  GoogleSignInServicec.swift
//  FitBB
//
//  Created by Акбар Уметов on 28/4/22.
//

import Foundation
import GoogleSignIn
import Firebase
import FirebaseDatabase
import Combine

class GoogleSignInService: ObservableObject {
    var signInConfig = GIDConfiguration.init(clientID: clientId)
    
    func signIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: presentingViewController) { user, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            guard let authentification = user?.authentication, let idToken = authentification.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentification.accessToken)
            
            Auth.auth().signIn(with: credential)
        }
    }
    
//    func signOut() {
//        let firebaseAuth = Auth.auth()
//
//        do {
//            try firebaseAuth.signOut()
//        } catch let sighOutError as NSError {
//            print("Error singing out: %@", sighOutError)
//        }
//    }
}
