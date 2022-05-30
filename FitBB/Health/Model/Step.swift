//
//  Step.swift
//  FitBB
//
//  Created by Акбар Уметов on 24/5/22.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

extension Step {
    static var new: Step {
        Step(count: 0,
             date: Date())
    }
}
