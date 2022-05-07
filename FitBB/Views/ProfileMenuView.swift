//
//  ProfileMenuView.swift
//  FitBB
//
//  Created by Акбар Уметов on 6/5/22.
//

import SwiftUI

struct ProfileMenuView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    var utilities = ColorSchemeUtilites()
    
    @AppStorage("selectedAppearance") var selectedAppearance = 1
    
    @Binding var showProfileMenu: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color("background"))
                    .edgesIgnoringSafeArea(.all)
                
                List {
                    Button(action: {
                        
                    }, label: {
                        HStack(spacing: 15) {
                            Image(systemName: "heart.text.square")
                                .resizedToFill(width: 25, height: 25)
                            
                            Text("Medical Info")
                        }
                        .foregroundColor(.black)
                    })
                    .listRowBackground(Color("background"))
                    
                    NavigationLink(destination: LinkAccountView(showProfileMenu: $showProfileMenu)) {
                            HStack(spacing: 15) {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizedToFill(width: 25, height: 25)
                                
                                Text("Link Accounts")
                            }
                            .foregroundColor(.black)
                    }
                    .listRowBackground(Color("background"))
                    
                    
                    HStack(spacing: 15) {
                        Image(systemName: "sun.max.circle")
                            .resizedToFill(width: 25, height: 25)
                        
                        Menu("Change Theme") {
                            Button {
                                selectedAppearance = 1
                            } label: {
                                Text("System Default")
                            }
                            
                            Button {
                                selectedAppearance = 2
                            } label: {
                                Text("Light")
                            }
                            
                            Button {
                                selectedAppearance = 3
                            } label: {
                                Text("Dark")
                            }
                        }
                        .onChange(of: selectedAppearance, perform: { value in
                            utilities.overrideDisplayMode()
                        })
                    }
                    .foregroundColor(.black)
                    .listRowBackground(Color("background"))
                    
                    Button(action: {
                        
                    }, label: {
                        HStack(spacing: 15) {
                            Image(systemName: "questionmark.circle")
                                .resizedToFill(width: 25, height: 25)
                            
                            Text("Support")
                        }
                        .foregroundColor(.black)
                    })
                    .listRowBackground(Color("background"))
                    
                    Button(action: {
                        sessionService.logout()
                        showProfileMenu.toggle()
                    }, label: {
                        HStack(spacing: 15) {
                            Image(systemName: "chevron.backward.circle")
                                .resizedToFill(width: 25, height: 25)
                            
                            Text("Logout")
                        }
                        .foregroundColor(.black)
                    })
                    .listRowBackground(Color("background"))
                }
            }
            .navigationBarHidden(true)
            
        }
    }
}

struct ProfileMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenuView(showProfileMenu: .constant(true))
            .environmentObject(SessionServiceImpl())
    }
}
