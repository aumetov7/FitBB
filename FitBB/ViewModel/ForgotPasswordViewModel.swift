//
//  ForgotPasswordViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 15/4/22.
//

import Foundation
import Combine

protocol ForgotPasswordViewModel {
    var service: ForgotPasswordService { get }
    var email: String { get }
    
    func sendPasswordReset()
    
    init(service: ForgotPasswordService)
}

final class ForgotPasswordViewModelImpl: ObservableObject, ForgotPasswordViewModel {
    @Published var email: String = ""
    
    let service: ForgotPasswordService
    private var subscriptions = Set<AnyCancellable>()
    
    func sendPasswordReset() {
        service
            .sendPasswordReset(to: email)
            .sink { res in
                switch res {
                case .failure(let err):
                    print("Failed: \(err)")
                default: break
                }
            } receiveValue: {
                print("Sent Password Reset Request")
            }
            .store(in: &subscriptions)
    }
    
    init(service: ForgotPasswordService) {
        self.service = service
    }
}
