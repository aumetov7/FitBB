//
//  BMRService.swift
//  FitBB
//
//  Created by Акбар Уметов on 27/5/22.
//

import Foundation
import HealthKit
import UIKit

protocol BMRService {
    func getDateOfBirth() -> DateComponents?
    func calculateAge() -> Int
    func getSex() -> HKBiologicalSexObject?
}

final class BMRServiceImpl: HealthStore, ObservableObject {
    func getDateOfBirth() -> DateComponents? {
        do {
            let dateOfBirth = try self.healthStore?.dateOfBirthComponents()
            
            return dateOfBirth
        } catch let error {
            print("Error while fetching date of birth: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func calculateAge() -> Int {
        let calendar = Calendar.current
        let now = calendar.dateComponents([.year, .month, .day], from: Date())
        
        guard let dateOfBirth = getDateOfBirth() else { return 0 }
        
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        
        return ageComponents.year!
    }
    
    func getSex() -> HKBiologicalSexObject? {
        do {
            let biologicalSex = try self.healthStore?.biologicalSex()
            
            return biologicalSex
        } catch let error {
            print("Error while fetching biological sex: \(error.localizedDescription)")
            
            return nil
        }
    }
}
