//
//  NewSignView.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct SignView: View {
    @State private var showSignUpView = false
    
    var body: some View {
        if !showSignUpView {
            SignInCombineView(showSignUpView: $showSignUpView)
        } else {
            SignUpView(showSignUpView: $showSignUpView)
        }
    }
}

struct SignView_Previews: PreviewProvider {
    static var previews: some View {
        SignView()
        
        SignView()
            .preferredColorScheme(.dark)
    }
}
