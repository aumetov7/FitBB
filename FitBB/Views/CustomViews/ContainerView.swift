//
//  ContainerView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/5/22.
//

import SwiftUI

struct ContainerView<Content: View>: View {
    var content: Content
    
    var body: some View {
        ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 25)
                    .foregroundColor(Color("background"))
            }
            
            content
        }
    }
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView {
            Text("Hello World")
        }
    }
}
