//
//  AnonymousAuthViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 18/5/22.
//

import Foundation
import Combine

enum AnonymousAuthState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol AnonymousAuthViewModel {
    var service: AnonymousAuthService { get }
    var state: AnonymousAuthState { get }
    var hasError: Bool { get }
    
    init(service: AnonymousAuthService)
    
    func anonymousAuth()
}

final class AnonymousAuthViewModelImpl: ObservableObject, AnonymousAuthViewModel {
    @Published var state: AnonymousAuthState = .notAvailable
    @Published var hasError: Bool = false
    
    let service: AnonymousAuthService
    
    private var subscriptions = Set<AnyCancellable>()
    
    func anonymousAuth() {
        service
            .anonymousAuth()
            .sink { res in
                switch res {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
    
    init(service: AnonymousAuthService) {
        self.service = service
        setupErrorSubscriptions()
    }
}

private extension AnonymousAuthViewModelImpl {
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
