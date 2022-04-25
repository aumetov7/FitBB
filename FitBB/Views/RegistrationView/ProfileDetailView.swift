//
//  AccountInfoRegistration.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct ProfileDetailView: View {
    @ObservedObject var updateProfileViewModel: UpdateProfileViewModelImpl
    
    @State private var firstName = ""
    @State private var dateOfBirth: Date?
    @State private var gender = ""
    @State private var goal = ""
    
    @Binding var showProfileDetailView: Bool
    
    var genderArray = ["Male", "Female", "Any"]
    var goalArray = ["Muscle grow", "Burn Fat", "Work Out"]
    
    var signUpText: some View {
        Text("Profile Detail")
            .font(.largeTitle)
            .fontWeight(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
    
    var firtNameTextField: some View {
        VStack(alignment: .leading) {
            Text("First name")
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.black)
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
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.black)
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
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.black)
            
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
                .fontWeight(.light)
                .font(.system(.callout))
                .foregroundColor(.black)
            
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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("background"))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                signUpText
                
                Spacer()
                
                VStack {
                    firtNameTextField
                    
                    dateOfBirthTextField
                    
                    genderPicker
                    
                    goalPicker
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                
                Spacer()
                
                RaisedButton(buttonText: "Update") {
                    updateProfileViewModel.update()
                    showProfileDetailView.toggle()
                }
                .padding(.horizontal)
                .padding(.bottom, 65)
            }
            .padding(.horizontal)
        }
    }
}

struct SignUpDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(updateProfileViewModel: UpdateProfileViewModelImpl(service: RegistrationServiceImpl()),
                             showProfileDetailView: .constant(true))
    }
}
