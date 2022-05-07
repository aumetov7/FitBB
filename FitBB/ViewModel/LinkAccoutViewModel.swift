//
//  LinkAccoutViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 7/5/22.
//

import Foundation
import Combine

enum LinkAccountState {
    case successfull
    case failed(error: Error)
    case notAvailable
}

protocol LinkAccountViewModel {
    func linkGoogleAccount()
    
    var service: LinkAccountService { get }
    var state: LinkAccountState { get }
    var hasError: Bool { get }
    
    init(service: LinkAccountService)
}

final class LinkAccountViewModelImpl: ObservableObject, LinkAccountViewModel {
    @Published var state: LinkAccountState = .notAvailable
    @Published var hasError: Bool = false
    
    let service: LinkAccountService
    
    private var subscription = Set<AnyCancellable>()
    
    func linkGoogleAccount() {
        service
            .linkGoogleAccount()
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
    
    init(service: LinkAccountService) {
        self.service = service
        setupErrorSubscriptions()
    }
}

private extension LinkAccountViewModelImpl {
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
