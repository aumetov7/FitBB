//
//  RegistrationViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import Foundation
import Combine

enum RegistrationState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol RegistrationViewModel {
    func register()
    
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var userDetails: RegistrationDetails { get }
    var hasError: Bool { get }
    
    init(service: RegistrationService)
}

final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    @Published var state: RegistrationState = .notAvailable
    @Published var hasError: Bool = false
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new
    
    let service: RegistrationService
    
    private var subscription = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func register() {
        service
            .register(with: userDetails)
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

extension RegistrationViewModelImpl {
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
