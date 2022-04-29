//
//  ContentView.swift
//  FitBB
//
//  Created by Акбар Уметов on 9/4/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PagesView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionServiceImpl())
            .environmentObject(GoogleSignInService())
    }
}
