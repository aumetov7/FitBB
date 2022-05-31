//
//  HealthStore.swift
//  FitBB
//
//  Created by Акбар Уметов on 24/5/22.
//

import Foundation
import HealthKit



class HealthStore {
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        //        let typesToShare: Set = [
        //            HKQuantityType.workoutType()
        //        ]
        
        let typesToRead: Set = [
            HKCharacteristicType.characteristicType(forIdentifier: .biologicalSex)!,
            HKCharacteristicType.characteristicType(forIdentifier: .dateOfBirth)!,
            //            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
            HKQuantityType.quantityType(forIdentifier: .height)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryProtein)!,
            HKQuantityType.quantityType(forIdentifier: .dietaryWater)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!
        ]
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead, completion: { success, error in
            completion(success)
        })
    }
}

extension HealthStore {
    func getQueryWithOptions(quantityType: HKQuantityType, options: HKStatisticsOptions) -> HKStatisticsCollectionQuery? {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        //        let startDate = Calendar.current.startOfDay(for: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        return HKStatisticsCollectionQuery(quantityType: quantityType,
                                           quantitySamplePredicate: predicate,
                                           options: options,
                                           anchorDate: anchorDate,
                                           intervalComponents: daily)
    }
    
    func getQueryWithoutOptions(quantityType: HKQuantityType) -> HKStatisticsCollectionQuery? {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        //        let startDate = Calendar.current.startOfDay(for: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: Date(),
                                                    options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: predicate,
                                                anchorDate: anchorDate,
                                                intervalComponents: daily)
        
        return query
    }
}
