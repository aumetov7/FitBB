//
//  AccountInfoRegistration.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct ProfileDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @StateObject private var profileImageService = ProfileImageService()
    
    @ObservedObject var updateProfileViewModel: UpdateProfileViewModelImpl
    
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    @Binding var showProfileDetailView: Bool
    
    var genderArray = ["Male", "Female", "Other"]
    var goalArray = ["Muscle Grow", "Burn Fat", "Work Out"]
    var daysArray = ["1", "2", "3", "4"]
    
    var color: Color {
        return colorScheme == .dark ? Color.white : Color(UIColor.lightGray)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                profileDetailsText
                    .frame(height: geometry.size.height / 10)
                
                ScrollView {
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            profileImage
                            addImageButton
                        }
                        .padding(.bottom)
                        
                            firtNameTextField
                            
                            dateOfBirthTextField
                            
                            segmentedPickerTextField(text: "Gender",
                                                     selection: $updateProfileViewModel.userDetails.gender,
                                                     array: genderArray)
                            
                            segmentedPickerTextField(text: "Goal",
                                                     selection: $updateProfileViewModel.userDetails.goal,
                                                     array: goalArray)
                            
                            segmentedPickerTextField(text: "Days",
                                                     selection: $updateProfileViewModel.userDetails.days,
                                                     array: daysArray)
                        
                        updateButton
                            .frame(height: geometry.size.height / 10, alignment: .bottom)
                            .padding(.bottom)
                    }
                }
                .frame(height: geometry.size.height / 1.2)
            }
            .frame(height: geometry.size.height)
            .padding(.horizontal)
            .onChange(of: inputImage) { newImage in
                loadImage()
                profileImageService.updateProfileImage(with: newImage!)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
            }
        }
        .customBackgroundColor(colorScheme: colorScheme)
        .ignoresSafeArea(.keyboard)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    var profileDetailsText: some View {
        Text("Profile Details")
            .titleText()
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
    
    var firtNameTextField: some View {
        VStack(alignment: .leading) {
            Text("First name")
                .signText()
            
            HStack {
                TextField("", text: $updateProfileViewModel.userDetails.firstName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.namePhonePad)
            }
            
            Divider()
                .background(color)
        }
        .padding(.horizontal)
    }
    
    var dateOfBirthTextField: some View {
        VStack(alignment: .leading) {
            Text("Date of birth")
                .signText()
            
            HStack {
                DatePickerTextField(placeholder: "", date: $updateProfileViewModel.userDetails.dateOfBirth)
            }
            .frame(height: 25)
            
            Divider()
                .background(color)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func segmentedPickerTextField(text: String, selection: Binding<String>, array: [String]) -> some View {
        VStack(alignment: .leading) {
            Text(text)
                .signText()
            
            HStack {
                Picker(text, selection: selection) {
                    ForEach(array, id:\.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Divider()
                .background(color)
        }
        .padding(.horizontal)
    }
    
    var updateButton: some View {
        RaisedButton(buttonText: "Update") {
            updateProfileViewModel.update()
            showProfileDetailView.toggle()
        }
        .padding(.horizontal)
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(updateProfileViewModel: UpdateProfileViewModelImpl(
            service: UpdateProfileServiceImpl()),
                          showProfileDetailView: .constant(true))
        .environmentObject(SessionServiceImpl())
        
        ProfileDetailView(updateProfileViewModel: UpdateProfileViewModelImpl(
            service: UpdateProfileServiceImpl()),
                          showProfileDetailView: .constant(true))
        .preferredColorScheme(.dark)
        .environmentObject(SessionServiceImpl())
        
        ProfileDetailView(updateProfileViewModel: UpdateProfileViewModelImpl(
            service: UpdateProfileServiceImpl()),
                          showProfileDetailView: .constant(true))
        .environmentObject(SessionServiceImpl())
        .previewDevice("iPhone 8")
    }
}
