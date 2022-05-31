//
//  ActiveEnergyBurnedViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 25/5/22.
//

import Foundation
import HealthKit
import Combine

enum ActiveEnergyBurnedState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol ActiveEnergyBurnedViewModel {
    var activeEnergyBurned: [ActiveEnergyBurned] { get }
//    var activeEnergyBurned: ActiveEnergyBurned { get }
    var service: ActiveEnergyBurnedService { get }
    var state: ActiveEnergyBurnedState { get }
    
    init(service: ActiveEnergyBurnedService)
    
    func countActiveEnergyBurned()
}

final class ActiveEnergyBurnedViewModelImpl: ObservableObject, ActiveEnergyBurnedViewModel {
    @Published var activeEnergyBurned: [ActiveEnergyBurned] = [ActiveEnergyBurned]()
//    @Published var activeEnergyBurned: ActiveEnergyBurned = ActiveEnergyBurned.new
    @Published var state: ActiveEnergyBurnedState = .notAvailable
    
    let service: ActiveEnergyBurnedService
    
    private var subscription = Set<AnyCancellable>()
    
    init(service: ActiveEnergyBurnedService) {
        self.service = service
        self.countActiveEnergyBurned()
    }
    
    func countActiveEnergyBurned() {
        service
            .calculateEneryBurned { statisticsCollection in
                if let statisticsCollection = statisticsCollection {
                    self.updateFromStatistics(statisticsCollection)
                }
            }
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscription)
    }
}

private extension ActiveEnergyBurnedViewModelImpl {
    func updateFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
//        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let caloriesBurned = statistics.sumQuantity()?.doubleValue(for: .kilocalorie())
            let energy = ActiveEnergyBurned(count: Int(caloriesBurned ?? 0), date: statistics.startDate)
            
            DispatchQueue.main.async {
//                self.activeEnergyBurned.append(energy)
                self.activeEnergyBurned.append(energy)
            }
            
            
        }
    }
}
