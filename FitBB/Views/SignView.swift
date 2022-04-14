//
//  SingView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct SignView: View {
    @State private var index = 0
    @State private var showRegistrationView = false
    @State private var contentViewShow = false
    @State private var showForgetPasswordView = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.clear)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "applelogo")
                    .font(.largeTitle)
                    .padding(.bottom, 15)
                    .foregroundColor(Color("Color1"))
                
                ZStack {
                    
                    SignUpView(index: $index, showRegistrationView: $showRegistrationView, contentViewShow: $contentViewShow)
                        .zIndex(Double(index))
                    SignInView(index: $index, showForgetPasswordView: $showForgetPasswordView)
                }
            }
        }
    }
}

struct SignView_Previews: PreviewProvider {
    static var previews: some View {
        SignView()
    }
}
