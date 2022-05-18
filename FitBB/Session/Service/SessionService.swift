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
    var medicalDetails: SessionMedicalDetails? { get }
    var loading: Bool { get }
    
    func getProviderId() -> [String]
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    @Published var medicalDetails: SessionMedicalDetails?
    @Published var loading: Bool = false
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func getProviderId() -> [String] {
        var providerIDArray: [String] = []
        
        
        guard let providerData = Auth.auth().currentUser?.providerData else { return providerIDArray }

        for userInfo in providerData {
            providerIDArray.append(userInfo.providerID)
        }
        
        return providerIDArray
    }
    
    func logout() {
        try? Auth.auth().signOut()
        userDetails = nil
        medicalDetails = nil
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
                    print("Detail UID: \(uid)")
                    self.accountInfoHandleRefresh(with: uid)
                    self.medicalInfoHandleRefresh(with: uid)
                }
            }
    }
    
    func accountInfoHandleRefresh(with uid: String) {
        Database
            .database()
            .reference()
            .child("users")
            .child(uid)
            .child("accountDetails")
            .observe(.value) { [weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? NSDictionary,
                      let profileImage = value[RegistrationKeys.profileImage.rawValue] as? String,
                      let firstName = value[RegistrationKeys.firstName.rawValue] as? String,
                      let dateOfBirth = value[RegistrationKeys.dateOfBirth.rawValue] as? String,
                      let gender = value[RegistrationKeys.gender.rawValue] as? String,
                      let goal = value[RegistrationKeys.goal.rawValue] as? String,
                      let days = value[RegistrationKeys.days.rawValue] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.userDetails = SessionUserDetails(profileImage: profileImage,
                                                          firstName: firstName,
                                                          dateOfBirth: dateOfBirth,
                                                          gender: gender,
                                                          goal: goal,
                                                          days: days)
                }
            }
    }
    
    func medicalInfoHandleRefresh(with uid: String) {
        Database
            .database()
            .reference()
            .child("users")
            .child(uid)
            .child("medicalDetails")
            .observe(.value) { [weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? NSDictionary,
                      let weight = value[MedicalInfoKeys.weight.rawValue] as? String,
                      let height = value[MedicalInfoKeys.height.rawValue] as? String,
                      let bloodPressure = value[MedicalInfoKeys.bloodPressure.rawValue] as? String,
                      let eyes = value[MedicalInfoKeys.eyes.rawValue] as? String,
                      let spine = value[MedicalInfoKeys.spine.rawValue] as? String,
                      let spinePartSelectedIndex = value[MedicalInfoKeys.spinePartSelectedIndex.rawValue] as? Int,
                      let heartSelectedIndex = value[MedicalInfoKeys.heartSelectedIndex.rawValue] as? Int,
                      let jointsAndLigamentsSelectedIndex = value[MedicalInfoKeys.jointsAndLigamentsSelectedIndex.rawValue] as? Int else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.medicalDetails = SessionMedicalDetails(weight: weight,
                                                                height: height,
                                                                bloodPressure: bloodPressure,
                                                                eyes: eyes, spine: spine,
                                                                spinePartSelectedIndex: spinePartSelectedIndex,
                                                                heartSelectedIndex: heartSelectedIndex,
                                                                jointsAndLigamentsSelectedIndex: jointsAndLigamentsSelectedIndex)
                }
            }
    }
}
