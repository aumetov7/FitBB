//
//  RegistrationView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct RegistrationView: View {
    @State private var age = ""
    @State private var currentGender = "Any"
    @State private var currentGoal = "Muscle grow"
    @State private var goal = ""
    @Binding var index: Int
    @Binding var contentViewShow: Bool
    
    var genderArray = ["Male", "Female", "Any"]
    var goalArray = ["Muscle grow", "Burn Fat", "Work Out"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    
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
                .padding(.top, 30)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "calendar")
                            .foregroundColor(Color("Color1"))
                        
                        TextField("Age", text: $age) // date of birth
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("Color1"))
                        
//                        SecureField("Gender", text: $currentGender)
                        Picker("Gender", selection: $currentGender) {
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
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "figure.walk")
                            .foregroundColor(Color("Color1"))
                        
                        Picker("Gender", selection: $currentGoal) {
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
            .padding()
            .padding(.bottom, 65)
            .background(Color("background"))
            .clipShape(SignUpCShape())
            .contentShape(SignUpCShape())
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: -2)
            .onTapGesture {
                index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            Button(action: {
                contentViewShow.toggle()
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("Color1"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(index == 1 ? 1 : 0)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(index: .constant(1), contentViewShow: .constant(false))
    }
}
