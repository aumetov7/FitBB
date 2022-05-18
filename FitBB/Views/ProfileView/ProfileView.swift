//
//  ProfileView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//
import SwiftUI

struct ProfileView: View {
    @StateObject private var updateProfileViewModel = UpdateProfileViewModelImpl(
        service: UpdateProfileServiceImpl()
    )
    
    @StateObject private var profileImageService = ProfileImageService()
    
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showProfileDetailView = false
    @State private var showProfileMenu = false
    @State private var showMedicalInfo = false
    @State private var showLinkAccount = false
    @State private var showMedicalInfoChatView = false
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: MedicalInfoCombineView(), isActive: $showMedicalInfo) {
                    EmptyView()
                }
                
                NavigationLink(destination: LinkAccountView(), isActive: $showLinkAccount) {
                    EmptyView()
                }
                
                HStack(alignment: .center) {
                    editButton
                    profileMenuButton
                }
                
                welcomeUserText
                
                ZStack(alignment: .bottomTrailing) {
                    profileImage
                    
                    addImageButton
                }
                .padding(.bottom, 50)
                
                userDetails
                
                Spacer()
            }
            .navigationBarHidden(true)
            .onChange(of: inputImage) { newImage in
                loadImage()
                profileImageService.updateProfileImage(with: newImage!)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .sheet(isPresented: $showProfileDetailView) {
                ProfileDetailView(updateProfileViewModel: updateProfileViewModel,
                                  showProfileDetailView: $showProfileDetailView)
            }
            .halfSheet(showSheet: $showProfileMenu, sheetView: {
                ProfileMenuView(showProfileMenu: $showProfileMenu,
                                showMedicalInfo: $showMedicalInfo,
                                showLinkAccount: $showLinkAccount)
                .environmentObject(sessionService)
            }, onEnd: {
                print("Dismiss")
            })
        }
        .task(checkInfo)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
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
        
        if sessionService.medicalDetails == nil || (sessionService.medicalDetails?.weight == "") {
            showMedicalInfoChatView.toggle()
        }
    }
    
    var profileMenuButton: some View {
        Button {
            showProfileMenu.toggle()
            print("ShowProfileMenu: \(showProfileMenu)")
        } label: {
            Image(systemName: "line.3.horizontal")
                .resizedToFill(width: 15, height: 15)
                .font(.headline)
                .foregroundColor(.black)
                .padding(5)
        }
        //        .buttonStyle(EmbossedButtonStyle())
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 25)
        .padding(.trailing, 20)
    }
    
    var editButton: some View {
        Button {
            showProfileDetailView.toggle()
        } label: {
            Text("Edit")
                .makeRound()
                .foregroundColor(.black)
                .padding([.leading, .trailing], 10)
        }
        //        .buttonStyle(EmbossedButtonStyle())
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 25)
        .padding(.leading, 20)
    }
    
    var welcomeUserText: some View {
        VStack {
            Text("Welcome")
                .titleText()
            
            Text("\(sessionService.userDetails?.firstName ?? "N/A")")
                .titleText()
                .padding(.bottom, 100)
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
                    .foregroundColor(.white)
                
                Text("""
                    Choose profile
                    photo
                    """)
                .multilineTextAlignment(.center)
            }
        }
        
    }
    
    var addImageButton: some View {
        Button(action: {
            showImagePicker.toggle() // true
        }) {
            Image(systemName: "plus")
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .background(Color.gray)
                .clipShape(Circle())
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
    }
}
