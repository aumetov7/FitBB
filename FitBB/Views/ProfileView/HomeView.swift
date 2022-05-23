//
//  HomeView.swift
//  FitBB
//
//  Created by Акбар Уметов on 23/5/22.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State private var showMenu = false
    @State private var showLinkAccount = false
    @State private var showProfileView = false
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var comma: String {
        return sessionService.userDetails?.firstName != nil ? ", " : ""
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    NavigationLink(destination: LinkAccountView(), isActive: $showLinkAccount) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: ProfileView(), isActive: $showProfileView) {
                        EmptyView()
                    }
                    
                    welcomeText
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        menuButton
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        profileButton
                    }
                }
                .halfSheet(showSheet: $showMenu, sheetView: {
                    ProfileMenuView(showProfileMenu: $showMenu,
                                    showLinkAccount: $showLinkAccount)
                    .environmentObject(sessionService)
                }, onEnd: {
                    print("Dismiss")
                })
            }
            .customBackgroundColor(colorScheme: colorScheme)
        }
    }
    
    var menuButton: some View {
        Button {
            showMenu.toggle()
            print("ShowMenu: \(showMenu)")
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(colorScheme == .dark ? Color("Color2") : Color.white)
                
                Image(systemName: "line.3.horizontal")
                    .resizedToFill(width: 15, height: 15)
                    .font(.headline)
                    .foregroundColor(color)
                    .padding(5)
            }
        }
    }
    
    var profileButton: some View {
        Button {
            showProfileView.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(colorScheme == .dark ? Color("Color2") : Color.white)
                
                AsyncImage(url: URL(string: sessionService.userDetails?.profileImage ?? "")) { image in
                    image
                        .resizedToFill(width: 35, height: 35)
                        .clipShape(Circle())
                        .padding(5)
                } placeholder: {
                    Image(systemName: "person.circle")
                        .resizedToFill(width: 35, height: 35)
                        .font(.headline)
                        .foregroundColor(color)
                        .padding(5)
                }
            }
        }
    }
    
    var welcomeText: some View {
        VStack {
            Text(sessionService.getCurrentTime() + comma)
                .rounedTitle()
            
            Text(sessionService.userDetails?.firstName ?? "")
                .rounedTitle()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SessionServiceImpl())
        
        HomeView()
            .environmentObject(SessionServiceImpl())
            .preferredColorScheme(.dark)
        
        HomeView()
            .environmentObject(SessionServiceImpl())
            .previewDevice("iPhone 8")
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(withURL url: String) {
        imageLoader = ImageLoader(urlString: url)
    }
    
    var body: some View {
        Image(uiImage: imageLoader.image ?? UIImage() )
            .resizedToFill(width: 35, height: 35)
            .clipShape(Circle())
            .padding(5)
    }
}
