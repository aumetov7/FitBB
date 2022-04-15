//
//  RegistrationView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct RegistrationViewSecondPage: View {
    @ObservedObject var regViewModel: RegistrationViewModelImpl
    
    @Binding var index: Int
    @Binding var showRegistrationView: Bool
    
    var genderArray = ["Male", "Female", "Any"]
    var goalArray = ["Muscle grow", "Burn Fat", "Work Out"]
    
    func check(firstName: String, gender: String, goal: String) -> Bool {
        if !firstName.isEmpty && !gender.isEmpty && !goal.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    var signUpText: some View {
        Button(action: {
            showRegistrationView.toggle()
            index = 1
        }) {
            VStack(spacing: 10) {
                Text("Sign Up")
                    .foregroundColor(index == 1 ? .black : .gray)
                    .font(.title)
                    .fontWeight(.black)
                
                Capsule()
                    .fill(index == 1 ? Color.black: Color.clear)
                    .frame(width: 100, height: 5)
            }
        }
    }
    
    var firstNameTextField: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "person.fill")
                    .foregroundColor(Color("Color1"))
                
                TextField("First Name", text: $regViewModel.userDetails.firstName)
            }
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 40)
    }
    
    var genderPicker: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "person.fill")
                    .foregroundColor(Color("Color1"))
                
                Picker("Gender", selection: $regViewModel.userDetails.gender) {
                    ForEach(genderArray, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
    
    var goalPicker: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "figure.walk")
                    .foregroundColor(Color("Color1"))
                
                Picker("Goal", selection: $regViewModel.userDetails.goal) {
                    ForEach(goalArray, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
    
    var signUpButton: some View {
        Button(action: {
            regViewModel.register()
        }) {
            Text("Sign Up")
                .foregroundColor(.white)
                .fontWeight(.black)
                .padding(.vertical)
                .padding(.horizontal, 50)
                .background(check(firstName: regViewModel.userDetails.firstName,
                                        gender: regViewModel.userDetails.gender,
                                        goal: regViewModel.userDetails.goal) ? Color("Color1") : Color.gray)
                .clipShape(Capsule())
                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .disabled(!check(firstName: regViewModel.userDetails.firstName,
                         gender: regViewModel.userDetails.gender,
                         goal: regViewModel.userDetails.goal))
        .offset(y: 25)
        .opacity(index == 1 ? 1 : 0)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    
                    signUpText
                }
                .padding(.top, 30)
                
                firstNameTextField
                
                genderPicker
                
                goalPicker
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("background"))
            .clipShape(SignUpCShape())
            .contentShape(SignUpCShape())
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: -2)
            .cornerRadius(35)
            .padding(.horizontal, 20)
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
            
            signUpButton
        }
    }
}

struct RegistrationViewSecondPage_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationViewSecondPage(regViewModel: RegistrationViewModelImpl(service: RegistrationServiceImpl()),
                                   index: .constant(1),
                                   showRegistrationView: .constant(false))
    }
}
