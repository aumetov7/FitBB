//
//  PagesView.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import SwiftUI

struct PagesView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .environmentObject(GoogleSignInService())
            
            ExercisesView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Exercises")
                }
            
            FoodView()
                .tabItem {
                    Image(systemName: "drop.fill")
                    Text("Food")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
            
            SuccessView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Success")
                }
        }
        .accentColor(.black)
    }
}

struct PagesView_Previews: PreviewProvider {
    static var previews: some View {
        PagesView()
            .environmentObject(SessionServiceImpl())
    }
}
