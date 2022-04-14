//
//  SignUpView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var regViewModel = RegistrationViewModelImpl(
        service: RegistrationServiceImpl()
    )
    
    @Binding var index: Int
    @Binding var showRegistrationView: Bool
    
    var body: some View {
        ZStack {
            if !showRegistrationView {
                RegistrationViewFirstPage(regViewModel: regViewModel,
                                          index: $index,
                                          showRegistrationView: $showRegistrationView)
            } else {
                RegistrationViewSecondPage(regViewModel: regViewModel,
                                           index: $index,
                                           showRegistrationView: $showRegistrationView)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(index: .constant(1), showRegistrationView: .constant(false))
    }
}
