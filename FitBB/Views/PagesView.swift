//
//  PagesView.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import SwiftUI

struct PagesView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        TabView {
            //            ProfileView()
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
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
        .accentColor(colorScheme == .dark ? .white : .black)
    }
}

struct PagesView_Previews: PreviewProvider {
    static var previews: some View {
        PagesView()
            .environmentObject(SessionServiceImpl())
        
        PagesView()
            .environmentObject(SessionServiceImpl())
            .preferredColorScheme(.dark)
    }
}
