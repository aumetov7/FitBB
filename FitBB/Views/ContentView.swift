//
//  ContentView.swift
//  FitBB
//
//  Created by Акбар Уметов on 9/4/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
