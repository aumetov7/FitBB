//
//  MedicalInfoService.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/5/22.
//

import Foundation
import Combine
import Firebase
import FirebaseDatabase

enum MedicalInfoKeys: String {
    case weight, height, bloodPressure, eyes, spine, spinePartSelectedIndex, heartSelectedIndex, jointsAndLigamentsSelectedIndex
}

protocol MedicalInfoService {
    func updateMedicalInfo(with details: MedicalDetails) -> AnyPublisher<Void, Error>
}

final class MedicalInfoServiceImpl: ObservableObject, MedicalInfoService {
    func updateMedicalInfo(with details: MedicalDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in

                guard let uid = Auth.auth().currentUser?.uid else { return }

                let values = [MedicalInfoKeys.weight.rawValue: details.weight,
                              MedicalInfoKeys.height.rawValue: details.height,
                              MedicalInfoKeys.bloodPressure.rawValue: details.bloodPressure,
                              MedicalInfoKeys.eyes.rawValue: details.eyes,
                              MedicalInfoKeys.spine.rawValue: details.spine,
                              MedicalInfoKeys.spinePartSelectedIndex.rawValue: details.spinePartSelectedIndex,
                              MedicalInfoKeys.heartSelectedIndex.rawValue: details.heartSelectedIndex,
                              MedicalInfoKeys.jointsAndLigamentsSelectedIndex.rawValue: details.jointsAndLigamentsSelectedIndex] as [String: Any]
                
                Database
                    .database()
                    .reference()
                    .child("users")
                    .child(uid)
                    .child("medicalDetails")
                    .updateChildValues(values) { error, ref in
                    if let error = error {
                        promise(.failure(error))
                        print("Database Error: \(error.localizedDescription)")
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }


}

