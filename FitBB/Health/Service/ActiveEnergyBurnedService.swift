//
//  ActiveEnergyBurnedService.swift
//  FitBB
//
//  Created by Акбар Уметов on 25/5/22.
//

import Foundation
import HealthKit
import Combine

protocol ActiveEnergyBurnedService {
    func calculateEneryBurned(completion: @escaping (HKStatisticsCollection?) -> Void) -> AnyPublisher<Void, Error>
    
    var query: HKStatisticsCollectionQuery? { get }
}

class ActiveEnergyBurnedServiceImpl: HealthStore, ActiveEnergyBurnedService {
    var query: HKStatisticsCollectionQuery?
    
    func calculateEneryBurned(completion: @escaping (HKStatisticsCollection?) -> Void) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let activeEnergyBurned = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
                
                self.query = self.getQueryWithOptions(quantityType: activeEnergyBurned, options: .cumulativeSum)
                
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
