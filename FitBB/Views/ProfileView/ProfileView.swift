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
    @State private var on = false
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("My Profile")
                    .roundedTitle()
                    .padding(.top)
                
                LazyVStack(alignment: .leading) {
                    goalDetails(imageName: "flag.fill",
                                color: .indigo,
                                titleText: "Goal",
                                detailsText: "\(sessionService.userDetails?.goal ?? "N/A")",
                                width: geometry.size.width * 0.08,
                                height: geometry.size.height * 0.01)
                    
                    goalDetails(imageName: "figure.walk",
                                color: .green,
                                titleText: "Steps",
                                detailsText: "\(sessionService.requiredStepValue ?? 0)",
                                width: geometry.size.width * 0.08,
                                height: geometry.size.height * 0.01)
                    
                    goalDetails(imageName: "bolt.fill",
                                color: .orange,
                                titleText: "Calories",
                                detailsText: "\(sessionService.bmrModel?.calculatedRequiredEnergy ?? 0)",
                                width: geometry.size.width * 0.08,
                                height: geometry.size.height * 0.01)
                }
                .padding(.horizontal)
                .frame(height: geometry.size.height * 0.6, alignment: .top)
                
                
                
                RaisedButton(buttonText: "Personal Details") {
                    showMedicalInfo.toggle()
                }
                .frame(height: geometry.size.height * 0.15, alignment: .bottom)
                .padding(.horizontal)
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
    
    @ViewBuilder
    func goalDetails(imageName: String,
                     color: Color,
                     titleText: String,
                     detailsText: String,
                     width: CGFloat,
                     height: CGFloat) -> some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizedToFill(width: width, height: height)
                    .foregroundColor(color)
                    .frame(width: 45)
                
                Text(titleText)
                    .font(.title3)
                
                Text(detailsText)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding([.top, .bottom])
            
            Divider()
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
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
        
        ProfileView()
            .environmentObject(SessionServiceImpl())
            .preferredColorScheme(.dark)
        
        ProfileView()
            .environmentObject(SessionServiceImpl())
            .previewDevice("iPhone 8")
    }
}
