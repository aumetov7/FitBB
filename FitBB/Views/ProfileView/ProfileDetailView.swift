//
//  AccountInfoRegistration.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct ProfileDetailView: View {
    @ObservedObject var updateProfileViewModel: UpdateProfileViewModelImpl
    
    @Binding var showProfileDetailView: Bool
    
    @State private var day = "3"
    
    var genderArray = ["Male", "Female", "Other"]
    var goalArray = ["Muscle Grow", "Burn Fat", "Work Out"]
    var days = ["1", "2", "3", "4"]
    
    var signUpText: some View {
        Text("Profile Details")
            .font(.largeTitle)
            .fontWeight(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
    
    var firtNameTextField: some View {
        VStack(alignment: .leading) {
            Text("First name")
                .signText()
                .padding(.leading)
            
            HStack {
                TextField("", text: $updateProfileViewModel.userDetails.firstName)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.namePhonePad)
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    var dateOfBirthTextField: some View {
        VStack(alignment: .leading) {
            Text("Date of birth")
                .signText()
                .padding(.leading)
            
            HStack {
                DatePickerTextField(placeholder: "", date: $updateProfileViewModel.userDetails.dateOfBirth)
            }
            .frame(height: 25)
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    var genderPicker: some View {
        VStack(alignment: .leading) {
            Text("Gender")
                .signText()
            
            HStack {
                Picker("Gender", selection: $updateProfileViewModel.userDetails.gender) {
                    ForEach(genderArray, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            
            Divider()
        }
        .padding(.horizontal)
    }
    
    var goalPicker: some View {
        VStack(alignment: .leading) {
            Text("Goal")
                .signText()
            
            HStack {
                Picker("Goal", selection: $updateProfileViewModel.userDetails.goal) {
                    ForEach(goalArray, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            
            Divider()
        }
        .padding(.horizontal)
    }
    
    var daysPicker: some View {
        VStack(alignment: .leading) {
            Text("Days")
                .signText()
            
            HStack {
                Picker("Days", selection: $updateProfileViewModel.userDetails.days) {
                    ForEach(days, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            
            Divider()
        }
        .padding(.horizontal)
    }
    
    var updateButton: some View {
        RaisedButton(buttonText: "Update") {
            updateProfileViewModel.update()
            showProfileDetailView.toggle()
        }
    }
    
    var body: some View {
//        ContainerView {
            VStack {
                Spacer()
                
                signUpText
                
                Spacer()
                
                VStack {
                    firtNameTextField
                    
                    dateOfBirthTextField
                    
                    genderPicker
                    
                    goalPicker
                    
                    daysPicker
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                
                Spacer()
                
                updateButton
                .padding(.horizontal)
                .padding(.bottom, 65)
            }
            .padding(.horizontal)
            .ignoresSafeArea(.keyboard)
//        }  
    }
}

struct SignUpDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(updateProfileViewModel: UpdateProfileViewModelImpl(service: RegistrationServiceImpl()),
                             showProfileDetailView: .constant(true))
    }
}
