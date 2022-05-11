//
//  NewSignUpView.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct SignUpCombineView: View {
    @StateObject private var regViewModel = RegistrationViewModelImpl(
        service: RegistrationServiceImpl()
    )
    
    @State private var showSignUpDetailInfoView = false
    
    @Binding var showSignUpView: Bool
    
    var body: some View {
        SignUpView(regViewModel: regViewModel,
                             showSignUpDetailInfoView: $showSignUpDetailInfoView,
                             showSignUpView: $showSignUpView)
    }
}

struct SignUpCombineView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpCombineView(showSignUpView: .constant(false))
    }
}
