//
//  UpdateProfileViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 25/4/22.
//

import Foundation
import Combine

enum UpdateProfileState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol UpdateProfileViewModel {
    func update()
    
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var userDetails: RegistrationDetails { get }
    var hasError: Bool { get }
    
    init(service: RegistrationService)
}

final class UpdateProfileViewModelImpl: ObservableObject, UpdateProfileViewModel {
    @Published var state: RegistrationState = .notAvailable
    @Published var hasError: Bool = false
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new
    
    let service: RegistrationService
    
    private var subscription = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func update() {
        service
            .updateAccountInfo(with: userDetails)
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

extension UpdateProfileViewModelImpl {
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
