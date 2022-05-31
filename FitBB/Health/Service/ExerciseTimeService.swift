//
//  ExerciseTimeService.swift
//  FitBB
//
//  Created by Акбар Уметов on 31/5/22.
//

import Foundation
import HealthKit
import Combine

protocol ExerciseTimeService {
    var query: HKStatisticsCollectionQuery? { get }
    
    func calculateEXerciseTime(completion: @escaping (HKStatisticsCollection?) -> Void) -> AnyPublisher<Void, Error>
}

final class ExerciseTimeServiceImpl: HealthStore, ExerciseTimeService {
    var query: HKStatisticsCollectionQuery?
    
    func calculateEXerciseTime(completion: @escaping (HKStatisticsCollection?) -> Void) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
                
                self.query = self.getQueryWithOptions(quantityType: exerciseTimeType, options: .cumulativeSum)
                
                self.query!.initialResultsHandler = { query, statisticsCollection, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        completion(statisticsCollection)
                    }
                }
                
                if let healthStore = self.healthStore,
                   let query = self.query {
                    healthStore.execute(query)
                    
                    promise(.success(()))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
