//
//  MedicalInfoViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/5/22.
//

import Foundation
import Combine

enum MedicalInfoState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol MedicalInfoViewModel {
    var service: MedicalInfoService { get }
    var state: MedicalInfoState { get }
    var medicalDetails: MedicalDetails { get }
    var hasError: Bool { get }

    init(service: MedicalInfoService)

    func updateMedicalInfo()
}

final class MedicalInfoViewModelImpl: ObservableObject, MedicalInfoViewModel {
    let service: MedicalInfoService
    @Published var state: MedicalInfoState = .notAvailable
    @Published var medicalDetails: MedicalDetails = MedicalDetails.new
    @Published var hasError: Bool = false

    private var subscription = Set<AnyCancellable>()

    init(service: MedicalInfoService) {
        self.service = service
        setupErrorSubscriptions()
    }

    func updateMedicalInfo() {
        service
            .updateMedicalInfo(with: medicalDetails)
            .sink { [weak self] res in
                switch res {
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

extension MedicalInfoViewModelImpl {
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case .successfull, .notAvailable:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}

