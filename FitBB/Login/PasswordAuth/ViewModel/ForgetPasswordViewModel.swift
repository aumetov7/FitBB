//
//  ForgetPasswordViewModel.swift
//  FitBB
//
//  Created by Акбар Уметов on 15/4/22.
//

import Foundation
import Combine

protocol ForgetPasswordViewModel {
    var service: ForgetPasswordService { get }
    var email: String { get }
    
    func sendPasswordReset()
    
    init(service: ForgetPasswordService)
}

final class ForgetPasswordViewModelImpl: ObservableObject, ForgetPasswordViewModel {
    @Published var email: String = ""
    
    let service: ForgetPasswordService
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
    
    init(service: ForgetPasswordService) {
        self.service = service
    }
}
