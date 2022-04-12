//
//  Exercise.swift
//  FitBB
//
//  Created by Акбар Уметов on 12/4/22.
//

import Foundation

struct Exercise {
    let exerciseName: String
    let videoName: String
    
    enum ExerciseEnum: String {
        case benchPress = "Bench Press" // жим лежа
        case dumbellBenchPress = "Dumbell Bench Press" // жим гантелей лежа
        case butterfly = "Butterfly" // бабочка
        case barbellCurls = "Barbell Curls" // подъем штанги на бицепс
        case altBicepsCurls = "Alt Biceps Curls" // супинация
        case altHammerCurls = "Alt Hammer Curls" // молотки
    }
}

extension Exercise {
    static let exercises = [
        Exercise(
            exerciseName: ExerciseEnum.benchPress.rawValue,
            videoName: "benchPress"),
        Exercise(
            exerciseName: ExerciseEnum.dumbellBenchPress.rawValue,
            videoName: "dumbellBenchPress"),
        Exercise(
            exerciseName: ExerciseEnum.butterfly.rawValue,
            videoName: "butterfly"),
        Exercise(
            exerciseName: ExerciseEnum.barbellCurls.rawValue,
            videoName: "barbellCurls"),
        Exercise(
            exerciseName: ExerciseEnum.altBicepsCurls.rawValue,
            videoName: "altBicepsCurls"),
        Exercise(
            exerciseName: ExerciseEnum.altHammerCurls.rawValue,
            videoName: "altHammerCurls")
    ]
}
