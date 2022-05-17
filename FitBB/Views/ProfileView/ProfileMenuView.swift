//
//  ProfileMenuView.swift
//  FitBB
//
//  Created by Акбар Уметов on 6/5/22.
//

import SwiftUI

struct ProfileMenuView: View {
    @AppStorage("selectedAppearance") var selectedAppearance = 1
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @Binding var showProfileMenu: Bool
    @Binding var showMedicalInfo: Bool
    @Binding var showLinkAccount: Bool
    
    var utilities = ColorSchemeUtilites()
    
    var body: some View {
        List {
            medicalInfoButton
            
            linkAccountsButton
            
            changeThemeMenu
            
            supportButton
            
            logoutButton
        }
    }
    
    @ViewBuilder
    func menuButtonLabel(imageName: String, buttonName: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: imageName)
                .resizedToFill(width: 25, height: 25)
            
            Text(buttonName)
        }
        .foregroundColor(.black)
    }
    
    var medicalInfoButton: some View {
        Button {
            dismiss()
            showProfileMenu.toggle()
            showMedicalInfo.toggle()
        } label: {
            menuButtonLabel(imageName: "heart.text.square",
                            buttonName: "Medical Info")
        }
        .listRowBackground(Color("background"))
    }
    
    var linkAccountsButton: some View {
        Button {
            dismiss()
            showProfileMenu.toggle()
            showLinkAccount.toggle()
        } label: {
            menuButtonLabel(imageName: "person.crop.circle.badge.plus",
                            buttonName: "Link Accounts")
        }
        .listRowBackground(Color("background"))
    }
    
    var changeThemeMenu: some View {
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
    }
    
    var supportButton: some View {
        Button(action: {
            
        }, label: {
            menuButtonLabel(imageName: "questionmark.circle",
                            buttonName: "Support")
        })
        .listRowBackground(Color("background"))
    }
    
    var logoutButton: some View {
        Button(action: {
            dismiss()
            showProfileMenu.toggle()
            sessionService.logout()
        }, label: {
            menuButtonLabel(imageName: "chevron.backward.circle",
                            buttonName: "Logout")
        })
        .listRowBackground(Color("background"))
    }
}

struct ProfileMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenuView(showProfileMenu: .constant(true),
                        showMedicalInfo: .constant(false),
                        showLinkAccount: .constant(false))
        .environmentObject(SessionServiceImpl())
    }
}
