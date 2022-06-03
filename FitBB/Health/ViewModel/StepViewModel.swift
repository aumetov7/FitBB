//
//  StepViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 24/5/22.
//

import Foundation
import HealthKit
import Combine
import UIKit

enum StepState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol StepViewModel {
//    var steps: [Step] { get }
    var steps: [Step] { get }
    var service: StepService { get }
    var state: StepState { get }
    
    init(service: StepService)
    
    func countSteps()
//    func getCurrentStepValue() -> CGFloat
//    func getStepValueArray() -> [CGFloat]
//    func getCurrentStepText() -> String
}

final class StepViewModelImpl: ObservableObject, StepViewModel {
    @Published var steps: [Step] = [Step]()
//    @Published var steps: Step = Step.new
    @Published var state: StepState = .notAvailable
    
    let service: StepService
    
    private var subscription = Set<AnyCancellable>()
    
    init(service: StepService) {
        self.service = service
        self.countSteps()
    }
    
    func countSteps() {
        service
            .calculateSteps { statisticsCollection in
                if let statisticsCollection = statisticsCollection {
                    self.updateUIFromStatistics(statisticsCollection)
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
    
//    func getCurrentStepValue() -> CGFloat {
//        return CGFloat(self.steps.last?.count ?? 0) / 10000
//    }
//
//    func getStepValueArray() -> [CGFloat] {
//        var stepValueArray: [CGFloat] = []
//        var stepValue: CGFloat?
//
//        for value in self.steps {
//            stepValue = CGFloat(value.count) / 10000
//        }
//
//        return stepValueArray
//    }
//
//    func getCurrentStepText() -> String {
//        if getCurrentStepValue() >= 0 && getCurrentStepValue() < 0.5 {
//            return "Warning"
//        } else if getCurrentStepValue() > 0.5 && getCurrentStepValue() < 0.75 {
//            return "On track"
//        } else {
//            return "Good job"
//        }
//    }
}

private extension StepViewModelImpl {
    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
//        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            
            DispatchQueue.main.async {
                self.steps.append(step)
//                self.steps = step
                
                print("Info: \(self.steps)")
            }
            
        }
    }
}
