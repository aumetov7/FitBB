//
//  ActiveEnergyBurned.swift
//  FitBB
//
//  Created by Акбар Уметов on 25/5/22.
//

import Foundation

struct ActiveEnergyBurned: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

extension ActiveEnergyBurned {
    static var new: ActiveEnergyBurned {
        ActiveEnergyBurned(count: 0,
                           date: Date())
    }
}
