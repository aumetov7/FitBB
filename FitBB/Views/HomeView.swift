//
//  HomeView.swift
//  FitBB
//
//  Created by Акбар Уметов on 23/5/22.
//

import SwiftUI
import HealthKit

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
    
    var currentProgress: CGFloat {
        if sessionService.userDetails == nil && sessionService.medicalDetails == nil {
            return 0.0
        } else if sessionService.userDetails != nil && sessionService.medicalDetails == nil {
            return 0.5
        } else if sessionService.userDetails == nil && sessionService.medicalDetails != nil {
            return 0.5
        } else {
            return 1.0
        }
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
                        .padding(.top)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        progressView(width: geometry.size.width * 0.6,
                                     height: geometry.size.height * 0.015)
                    }
                }
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
                    if sessionService.userDetails == nil || sessionService.medicalDetails == nil {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .resizedToFill(width: 35, height: 35)
                            .font(.headline)
                            .foregroundColor(color)
                            .padding(5)
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizedToFill(width: 35, height: 35)
                            .font(.headline)
                            .foregroundColor(color)
                            .padding(5)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func progressView(width: CGFloat, height: CGFloat) -> some View {
        if sessionService.userDetails == nil || sessionService.medicalDetails == nil {
            VStack {
                if sessionService.userDetails == nil && sessionService.medicalDetails == nil {
                    Text("Complete your Profile")
                        .signText()
                        .fixedSize()
                } else if sessionService.userDetails != nil && sessionService.medicalDetails == nil {
                    Text("Complete Medical Details")
                } else if sessionService.userDetails == nil && sessionService.medicalDetails != nil {
                    Text("Complete your Profile Details")
                } else {
                    Text("Great work!")
                }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray)
                        .frame(width: width,
                               height: height)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.green)
                        .frame(width: width * currentProgress,
                               height: height)
                }
            }
        } else {
            EmptyView()
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
