//
//  StepService.swift
//  FitBB
//
//  Created by Акбар Уметов on 25/5/22.
//

import Foundation
import Combine
import HealthKit

protocol StepService {
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) -> AnyPublisher<Void, Error>
    
    var query: HKStatisticsCollectionQuery? { get }
}

class StepServiceImpl: HealthStore, StepService {
    var query: HKStatisticsCollectionQuery?
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
                
                self.query = self.getQueryWithOptions(quantityType: stepType, options: .cumulativeSum)
                
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
