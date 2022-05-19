//
//  AccountInfoRegistration.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct ProfileDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var updateProfileViewModel: UpdateProfileViewModelImpl
    
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
                Spacer()
                
                signUpText
                
                Spacer()
                
                VStack {
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
                }
                .frame(height: 316, alignment: .center)
                .padding(.bottom, 25)
                
                Spacer()
                
                updateButton
                    .padding(.horizontal)
                    .padding(.bottom, 65)
            }
            .padding(.horizontal)
            .customBackgroundColor(colorScheme: colorScheme)
        }
        .ignoresSafeArea(.keyboard)
    }
    
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
                .background(color)
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
                .background(color)
                .padding(.horizontal)
        }
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
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(updateProfileViewModel: UpdateProfileViewModelImpl(
                            service: UpdateProfileServiceImpl()),
                          showProfileDetailView: .constant(true))
        
        ProfileDetailView(updateProfileViewModel: UpdateProfileViewModelImpl(
                            service: UpdateProfileServiceImpl()),
                          showProfileDetailView: .constant(true))
        .preferredColorScheme(.dark)
    }
}
