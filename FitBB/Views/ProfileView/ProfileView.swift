//
//  ProfileView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//
import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @StateObject private var updateProfileViewModel = UpdateProfileViewModelImpl(
        service: UpdateProfileServiceImpl()
    )
    
    @State private var showProfileDetailView = false
    @State private var showMedicalInfo = false
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Profile")
                    .roundedTitle()
                    .padding(.top)
                
                profileImage
                    .padding([.bottom, .top])
                
                userDetails
                    .frame(height: geometry.size.height / 4)
                
                RaisedButton(buttonText: "Medical Info") {
                    showMedicalInfo.toggle()
                }
                .padding([.horizontal, .bottom, .top])
            }
            .padding(.horizontal)
            .sheet(isPresented: $showProfileDetailView) {
                ProfileDetailView(updateProfileViewModel: updateProfileViewModel,
                                  showProfileDetailView: $showProfileDetailView)
            }
            .sheet(isPresented: $showMedicalInfo, content: {
                MedicalInfoCombineView()
            })
            .task(checkInfo)
        }
        .customBackgroundColor(colorScheme: colorScheme)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                editButton
            }
        }
    }
    
    @Sendable private func checkInfo() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if sessionService.userDetails == nil ||
            (sessionService.userDetails?.firstName == "" &&
             sessionService.userDetails?.dateOfBirth == "" &&
             sessionService.userDetails?.gender == "" &&
             sessionService.userDetails?.goal == "" &&
             sessionService.userDetails?.days == "") {
            showProfileDetailView.toggle()
        }
    }
    
    var editButton: some View {
        Button {
            showProfileDetailView.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(colorScheme == .dark ? Color("Color2") : Color.white)
                
                Text("Edit")
                    .makeRound()
                    .foregroundColor(color)
                    .padding([.leading, .trailing], 10)
            }
        }
    }
    
    var profileImage: some View {
        AsyncImage(url: URL(string: sessionService.userDetails?.profileImage ?? "")) { image in
            image
                .resizedToFill(width: 150, height: 150)
                .clipShape(Circle())
        } placeholder: {
            ZStack {
                Circle()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray.opacity(0.15))
                
                ProgressView()
            }
        }
    }
    
    var userDetails: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Birth Date: \(sessionService.userDetails?.dateOfBirth ?? "N/A")")
                .makeRound()
            
            Text("Gender: \(sessionService.userDetails?.gender ?? "N/A")")
                .makeRound()
            
            Text("Goal: \(sessionService.userDetails?.goal ?? "N/A")")
                .makeRound()
            
            Text("Workout Days: \(sessionService.userDetails?.days ?? "N/A")")
                .makeRound()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.leading)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
        
        ProfileView()
            .environmentObject(SessionServiceImpl())
            .preferredColorScheme(.dark)
    }
}
