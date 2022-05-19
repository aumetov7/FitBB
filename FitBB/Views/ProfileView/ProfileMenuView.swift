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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @Binding var showProfileMenu: Bool
    @Binding var showMedicalInfo: Bool
    @Binding var showLinkAccount: Bool
    
    var utilities = ColorSchemeUtilites()
    
    var body: some View {
        GeometryReader { geometry in
            LazyVStack(alignment: .leading) {
                medicalInfoButton
                divider(size: geometry.size.width * 0.1)
                
                linkAccountsButton
                divider(size: geometry.size.width * 0.1)
                
                changeThemeMenu
                divider(size: geometry.size.width * 0.1)
                
                supportButton
                divider(size: geometry.size.width * 0.1)
                
                logoutButton
                divider(size: geometry.size.width * 0.1)
            }
            .padding()
        }
        .customBackgroundColor(colorScheme: colorScheme)
    }
    
    @ViewBuilder
    func divider(size: CGFloat) -> some View {
        Divider()
            .background(colorScheme == .dark ? Color.white : Color(UIColor.lightGray))
            .padding(.leading, size)
    }
    
    @ViewBuilder
    func menuButtonLabel(imageName: String, buttonName: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: imageName)
                .resizedToFill(width: 25, height: 25)
            
            Text(buttonName)
                .makeRound()
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
    
    var medicalInfoButton: some View {
        Button {
            dismiss()
            showProfileMenu.toggle()
            showMedicalInfo.toggle()
        } label: {
            menuButtonLabel(imageName: "heart.text.square",
                            buttonName: "Medical Info")
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding([.top, .bottom], 10)
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
        .padding([.top, .bottom], 10)
    }
    
    var changeThemeMenu: some View {
        Menu {
            Button {
                selectedAppearance = 1
            } label: {
                HStack {
                    Text("System Default")
                        .makeRound()
                    
                    if selectedAppearance == 1 {
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
            
            Button {
                selectedAppearance = 2
            } label: {
                HStack {
                    Text("Light")
                        .makeRound()
                    
                    if selectedAppearance == 2 {
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
            
            Button {
                selectedAppearance = 3
            } label: {
                HStack {
                    Text("Dark")
                        .makeRound()
                    
                    if selectedAppearance == 3 {
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
        } label: {
            menuButtonLabel(imageName: "sun.max.circle", buttonName: "Change Theme")
        }
        .onChange(of: selectedAppearance, perform: { value in
            utilities.overrideDisplayMode()
        })
        .padding([.top, .bottom], 10)
    }
    
    var supportButton: some View {
        Button(action: {
            
        }, label: {
            menuButtonLabel(imageName: "questionmark.circle",
                            buttonName: "Support")
        })
        .padding([.top, .bottom], 10)
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
        .padding([.top, .bottom], 10)
    }
}

struct ProfileMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenuView(showProfileMenu: .constant(true),
                        showMedicalInfo: .constant(false),
                        showLinkAccount: .constant(false))
        .environmentObject(SessionServiceImpl())
        
        ProfileMenuView(showProfileMenu: .constant(true),
                        showMedicalInfo: .constant(false),
                        showLinkAccount: .constant(false))
        .environmentObject(SessionServiceImpl())
        .preferredColorScheme(.dark)
    }
}
