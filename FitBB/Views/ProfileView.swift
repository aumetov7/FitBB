//
//  ProfileView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//
import SwiftUI

struct ProfileView: View {
    @StateObject private var updateProfileViewModel = UpdateProfileViewModelImpl(
        service: RegistrationServiceImpl()
    )
    
    @StateObject private var profileImageService = ProfileImageService()
    
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showProfileDetailView = false
    @State private var showImageAddButton = true
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var googleSignInService: GoogleSignInService
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    @Sendable private func checkInfo() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        //        if sessionService.userDetails == nil {
        //            showProfileDetailView.toggle()
        //        }
        
        if sessionService.userDetails == nil ||
            (sessionService.userDetails?.firstName == "" &&
             sessionService.userDetails?.dateOfBirth == "" &&
             sessionService.userDetails?.gender == "" &&
             sessionService.userDetails?.goal == "") {
            showProfileDetailView.toggle()
        }
        
        print("Detail view appear: \(showProfileDetailView)")
    }
    
    var logoutButton: some View {
        HStack {
            Button(action: {
                sessionService.logout()
                //                        googleSignInService.signOut()
            }, label: {
                HStack {
                    Image(systemName: "chevron.backward.circle")
                        .font(.headline)
                    Text("Logout")
                        .fontWeight(.medium)
                }
            })
            .buttonStyle(EmbossedButtonStyle())
            .padding(.trailing)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 25)
    }
    
    var welcomeUserText: some View {
        VStack {
            Text("Welcome")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .kerning(0.7)
            
            
            Text("\(sessionService.userDetails?.firstName ?? "N/A")")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .kerning(0.7)
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.leading)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("background"))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                logoutButton
                
                welcomeUserText
                
                ZStack(alignment: .bottomTrailing) {
                    profileImage
                    
                    addImageButton
                }
                .padding(.bottom, 50)
                
                userDetails
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
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
        }
        .task(checkInfo)
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
            .environmentObject(GoogleSignInService())
    }
}
