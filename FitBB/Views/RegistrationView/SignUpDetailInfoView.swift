//
//  AccountInfoRegistration.swift
//  FitBB
//
//  Created by Акбар Уметов on 20/4/22.
//

import SwiftUI

struct SignUpDetailInfoView: View {
    @ObservedObject var regViewModel: RegistrationViewModelImpl
    
    var genderArray = ["Male", "Female", "Any"]
    var goalArray = ["Muscle grow", "Burn Fat", "Work Out"]
    
    var signUpText: some View {
        Text("SIGN UP")
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
                TextField("", text: $regViewModel.userDetails.firstName)
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
                DatePickerTextField(placeholder: "", date: $regViewModel.userDetails.dateOfBirth)
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
                
                Picker("Gender", selection: $regViewModel.userDetails.gender) {
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
                
                Picker("Goal", selection: $regViewModel.userDetails.goal) {
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
                
                RaisedButton(buttonText: "Sign Up") {
                    regViewModel.register()
                }
                .padding(.horizontal)
                .padding(.bottom, 65)
                .alert(isPresented: $regViewModel.hasError,
                       content: {
                    if case .failed(let error) = regViewModel.state {
                        return Alert(title: Text("Error"),
                                     message: Text(error.localizedDescription))
                    } else {
                        return Alert(title: Text("Error"),
                                     message: Text("Something went wrong"))
                    }
                })
            }
            .padding(.horizontal)
        }
    }
}

struct SignUpDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpDetailInfoView(regViewModel: RegistrationViewModelImpl(service: RegistrationServiceImpl()))
    }
}
