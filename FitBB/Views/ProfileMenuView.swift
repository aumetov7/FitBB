//
//  ProfileMenuView.swift
//  FitBB
//
//  Created by Акбар Уметов on 6/5/22.
//

import SwiftUI

struct ProfileMenuView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("background"))
                .edgesIgnoringSafeArea(.all)
            
            List {
                Button(action: {
                    
                }, label: {
                    HStack(spacing: 15) {
                        Image(systemName: "person.crop.circle")
                            .resizedToFill(width: 25, height: 25)
                        
                        Text("Link Accounts")
                    }
                    .foregroundColor(.black)
                })
                
                Button(action: {
                    sessionService.logout()
                }, label: {
                    HStack(spacing: 15) {
                        Image(systemName: "chevron.backward.circle")
                            .resizedToFill(width: 25, height: 25)
                        
                        Text("Logout")
                    }
                    .foregroundColor(.black)
                })
            }
            .listRowSeparator(.hidden)
        }
    }
}

struct ProfileMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenuView()
            .environmentObject(SessionServiceImpl())
    }
}
