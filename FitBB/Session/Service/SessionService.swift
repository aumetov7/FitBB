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
import UIKit

enum SessionState {
    case loggedIn, loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    var medicalDetails: SessionMedicalDetails? { get }
    var bmrModel: BMRModel? { get }
    var fetched: Bool { get }
    var requiredStepValue: Int? { get }
    var currentStepValue: CGFloat { get }
    
    func getProviderId() -> [String]
    func logout()
    func getCurrentTime() -> String
    func calculateRequiredEnergy() -> Int
    func currentBurnedCalories() -> CGFloat
    func getCurrentCaloriesText() -> String
    func createBMRModel()
    func getRequiredStepsValue()
    func getCurrentStepValue() -> CGFloat
    func getDateArray() -> [String]
    func getStepArray() -> [Double]
//    func getStepDict() -> [String:Int]
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    @Published var medicalDetails: SessionMedicalDetails?
    @Published var bmrModel: BMRModel?
    @Published var fetched: Bool = false
    @Published var requiredStepValue: Int?
    @Published var currentStepValue: CGFloat = 0
    
    private var handler: AuthStateDidChangeListenerHandle?
    private var bmrService = BMRServiceImpl()
    private var activeEnergyBurnedVM = ActiveEnergyBurnedViewModelImpl(service: ActiveEnergyBurnedServiceImpl())
    private var stepVM = StepViewModelImpl(service: StepServiceImpl())
    
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
    
    func getCurrentTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6 ..< 12: return "Good Morning"
        case 12 ..< 18: return "Good Afternoon"
        case 18 ..< 24: return "Good Evening"
        default: return "Good Night"
        }
    }
    
    func calculateRequiredEnergy() -> Int {
        let age = self.bmrService.calculateAge()
        let sex = self.bmrService.getSex()
        let activityLevel = 1.375
        
        guard let doubleWeight = Double(self.medicalDetails?.weight ?? "") else { return 0 }
        guard let doubleHeight = Double(self.medicalDetails?.height ?? "") else { return 0 }
        
        let weightFormula = 10 * doubleWeight
        let heightFormula = 6.25 * doubleHeight
        let ageFormula = 5 * Double(age)
        let combinedFormula = weightFormula + heightFormula - ageFormula
        
        var formula: Double
        
        switch sex?.biologicalSex {
        case .male:
            formula = combinedFormula + 5
        case .female:
            formula = combinedFormula - 161
        case .other:
            formula = 0
        default:
            if self.userDetails?.gender == "male" {
                formula = combinedFormula + 5
            } else if self.userDetails?.gender == "female" {
                formula = combinedFormula - 161
            } else {
                formula = 0
            }
        }
        
        let result = Int(formula * activityLevel - formula)
        
        print("Result cre: \(result)")
        print("Result age: \(age)")
        print("Result weightFormula: \(weightFormula)")
        print("Result heightFormula: \(heightFormula)")
        print("Result ageFormula: \(ageFormula)")
        print("Result combinedFormula: \(combinedFormula)")
        print("Result formula: \(formula)")
        
        return result
    }
    
    func currentBurnedCalories() -> CGFloat {
        let result = CGFloat(activeEnergyBurnedVM.activeEnergyBurned.last?.count ?? 0) / CGFloat(self.calculateRequiredEnergy())
        print("Result cbc: \(result)")
        return result
    }
    
    func getCurrentCaloriesText() -> String {
        guard let currentBurnedCalories = self.bmrModel?.currentBurnedCalories else { return "Warning" }
        
        if currentBurnedCalories >= 0 && currentBurnedCalories < 0.5 {
            return "Warning"
        } else if currentBurnedCalories > 0.5 && currentBurnedCalories < 0.75 {
            return "On track"
        } else {
            return "Good job"
        }
    }
    
    func createBMRModel() {
        self.bmrModel = BMRModel(calculatedRequiredEnergy: calculateRequiredEnergy(),
                                 currentBurnedCalories: currentBurnedCalories())
    }
    
    func getRequiredStepsValue() {
        guard let goal = self.userDetails?.goal else { return }
        if goal == "Muscle Grow" {
            requiredStepValue = 10000
        } else if goal == "Burn Fat" {
            requiredStepValue = 12000
        } else {
            requiredStepValue = 15000
        }
    }
    
    func getCurrentStepValue() -> CGFloat {
        guard let requiredStepValue = requiredStepValue else {
            return 0
        }

        
        return CGFloat(self.stepVM.steps.last?.count ?? 0) / CGFloat(requiredStepValue)
    }
    
    func getDateArray() -> [String] {
        var dateArray: [String] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        for value in self.stepVM.steps {
            dateArray.append(dateFormatter.string(from: value.date))
        }
        
        print("Array date: \(dateArray)")
        return dateArray
    }
    
    func getStepArray() -> [Double] {
        var stepArray: [Double] = []
        
        for value in self.stepVM.steps {
            stepArray.append(Double(value.count))
        }
        
        print("Array step: \(stepArray)")
        return stepArray
    }
    
    func getCurrentStepText() -> String {
        if self.getCurrentStepValue() >= 0 && self.getCurrentStepValue() < 0.5 {
            return "Warning"
        } else if self.getCurrentStepValue() > 0.5 && self.getCurrentStepValue() < 0.75 {
            return "On track"
        } else {
            return "Good job"
        }
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
                    self.checkFetching(with: uid)
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
                    
                    self.getRequiredStepsValue()
                }
                
                self.fetched = true
            }
    }
    
    func checkFetching(with uid: String) {
        Database
            .database()
            .reference()
            .child("users")
            .observe(.value) { snapshot in
                if !snapshot.hasChild(uid) {
                    self.fetched = true
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
                    
                    self.createBMRModel()
                }
            }
    }
}
