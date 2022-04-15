//
//  LoginViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import Foundation
import Combine

enum LoginState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol LoginViewModel {
    func login()
    
    var service: LoginService { get }
    var state: LoginState { get }
    var credential: LoginCredentials { get }
    var hasError: Bool { get }
    
    init(service: LoginService)
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    @Published var hasError: Bool = false
    @Published var state: LoginState = .notAvailable
    @Published var credential: LoginCredentials = LoginCredentials.new
    
    let service: LoginService
    
    private var subscriptions = Set<AnyCancellable>()
    
    func login() {
        service
            .login(with: credential)
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
    
    init(service: LoginService) {
        self.service = service
        setupErrorSubscriptions()
    }
}

private extension LoginViewModelImpl {
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
