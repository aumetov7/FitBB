//
//  GoogleSignInViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 3/5/22.
//

import Foundation
import Combine

enum GoogleSignInState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol GoogleSignInViewModel {
    func signIn()
    
    var service: GoogleSignInService { get }
    var state: GoogleSignInState { get }
    var hasError: Bool { get }
    
    init(service: GoogleSignInService)
}

final class GoogleSignInViewModelImpl: ObservableObject, GoogleSignInViewModel {
    @Published var hasError: Bool = false
    @Published var state: GoogleSignInState = .notAvailable
    
    let service: GoogleSignInService
    
    private var subscription = Set<AnyCancellable>()
    
    func signIn() {
        service
            .signIn()
            .sink { res in
                switch res {
                case .failure(let error):
                    self.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscription)
    }
    
    init(service: GoogleSignInService) {
        self.service = service
        setupErrorSubscriptions()
    }
}

private extension GoogleSignInViewModelImpl {
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
