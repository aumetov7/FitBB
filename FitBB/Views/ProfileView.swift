//
//  ProfileView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        VStack {
            Text("Welcome")
            Text("First Name: \(sessionService.userDetails?.firstName ?? "N/A")")
            Text("Birth Date: \(sessionService.userDetails?.dateOfBirth ?? "N/A")")
            Text("Gender: \(sessionService.userDetails?.gender ?? "N/A)")")
            Text("Goal: \(sessionService.userDetails?.goal ?? "N/A)")")
            
            Button {
                sessionService.logout()
            } label: {
                Text("Logout")
            }
        }
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
    }
}
