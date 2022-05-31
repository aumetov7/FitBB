//
//  ExerciseTime.swift
//  FitBB
//
//  Created by Акбар Уметов on 31/5/22.
//

import Foundation

struct ExerciseTime {
//    let id = UUID()
    let count: Int
    let date: Date
}

extension ExerciseTime {
    static var new: ExerciseTime {
        ExerciseTime(count: 0,
                     date: Date())
    }
}
