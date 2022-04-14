//
//  SignInView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct SignInView: View {
    @Binding var index: Int
    @Binding var showForgetPasswordView: Bool
    
    var body: some View {
        ZStack {
            if !showForgetPasswordView {
                SignInViewPage(index: $index,
                               showForgetPasswordView: $showForgetPasswordView)
            } else {
                ForgetPasswordView(index: $index,
                                   showForgetPasswordView: $showForgetPasswordView)
            } 
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(index: .constant(0), showForgetPasswordView: .constant(false))
    }
}
