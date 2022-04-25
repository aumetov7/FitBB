//
//  SessionService.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import Combine
import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase

enum SessionState {
    case loggedIn, loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
}

private extension SessionServiceImpl {
    func setupFirebaseAuthHandler() {
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] res, user in
                guard let self = self else { return }
                self.state = user == nil ? .loggedOut : .loggedIn
                
                if let uid = user?.uid {
                    self.handleRefresh(with: uid)
                }
            }
    }
    
    func handleRefresh(with uid: String) {
        Database
            .database()
            .reference()
            .child("users")
            .child(uid)
            .observe(.value) { [weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? NSDictionary,
                      let firstName = value[RegistrationKeys.firstName.rawValue] as? String,
                      let dateOfBirth = value[RegistrationKeys.dateOfBirth.rawValue] as? String,
                      let gender = value[RegistrationKeys.gender.rawValue] as? String,
                      let goal = value[RegistrationKeys.goal.rawValue] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.userDetails = SessionUserDetails(firstName: firstName,
                                                          dateOfBirth: dateOfBirth,
                                                          gender: gender,
                                                          goal: goal)
                }
                
                print("Detail First Name: \(firstName)")
                print("Detail Date of Birth: \(dateOfBirth)")
                print("Detail Gender: \(gender)")
                print("Detail Goal: \(goal)")
            }
    }
}
