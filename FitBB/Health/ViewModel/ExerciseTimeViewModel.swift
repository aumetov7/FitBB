//
//  ExerciseTimeViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 31/5/22.
//

import Foundation
import HealthKit
import Combine
import UIKit

enum ExerciseTimeState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol ExerciseTimeViewModel {
    var exercisesTime: [ExerciseTime] { get }
    var service: ExerciseTimeService { get }
    var state: ExerciseTimeState { get }
    
    init(service: ExerciseTimeService)
    
    func countExerciseTime()
    func getCurrentExerciseTimeValue() -> CGFloat
    func getCurrentExerciseTimeText() -> String
}

final class ExerciseTimeViewModelImpl: ObservableObject, ExerciseTimeViewModel {
//    @Published var exercisesTime: ExerciseTime = ExerciseTime.new
    @Published var exercisesTime: [ExerciseTime] = [ExerciseTime]()
    @Published var state: ExerciseTimeState = .notAvailable
    
    let service: ExerciseTimeService
    
    private var subscription = Set<AnyCancellable>()
    
    init(service: ExerciseTimeService) {
        self.service = service
        self.countExerciseTime()
    }
    
    func countExerciseTime() {
        service
            .calculateEXerciseTime { statisticsCollection in
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
    
    func getCurrentExerciseTimeValue() -> CGFloat {
        return CGFloat(self.exercisesTime.last?.count ?? 0) / 60
    }
    
    func getCurrentExerciseTimeText() -> String {
        if getCurrentExerciseTimeValue() == 0 {
            return ""
        } else if getCurrentExerciseTimeValue() > 0 && getCurrentExerciseTimeValue() < 0.5 {
            return "Warning"
        } else if getCurrentExerciseTimeValue() > 0.5 && getCurrentExerciseTimeValue() < 0.75 {
            return "On track"
        } else {
            return "Good job"
        }
    }
}

private extension ExerciseTimeViewModelImpl {
    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
//        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .minute())
            let exerciseTime = ExerciseTime(count: Int(count ?? 0), date: statistics.startDate)
            
            DispatchQueue.main.async {
                self.exercisesTime.append(exerciseTime)
                
                print("Info: \(self.exercisesTime)")
            }
        }
    }
}
