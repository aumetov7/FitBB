//
//  NewSignView.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct SignView: View {
    @State private var showSignUpVuew = false
    
    var body: some View {
        if !showSignUpVuew {
            SignInCombineView(showSignUpView: $showSignUpVuew)
                .environmentObject(GoogleSignInService())
        } else {
            SignUpCombineView(showSignUpView: $showSignUpVuew)
        }
    }
}

struct SignView_Previews: PreviewProvider {
    static var previews: some View {
        SignView()
    }
}
