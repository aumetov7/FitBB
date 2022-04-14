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
    @Binding var contentViewShow: Bool
    
    var body: some View {
        ZStack {
            if !contentViewShow {
                if !showRegistrationView {
                    RegistrationViewFirstPage(regViewModel: regViewModel,
                                              index: $index,
                                              showRegistrationView: $showRegistrationView)
                } else {
                    RegistrationViewSecondPage(regViewModel: regViewModel,
                                               index: $index,
                                               contentViewShow: $contentViewShow,
                                               showRegistrationView: $showRegistrationView)
                }
            } else {
                PagesView()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(index: .constant(1), showRegistrationView: .constant(false), contentViewShow: .constant(false))
    }
}
