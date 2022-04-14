//
//  SignUpView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    @Binding var index: Int
    @Binding var showRegistrationView: Bool
    
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
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color("Color1"))
                        
                        TextField("Email Address", text: $email)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color1"))
                        
                        SecureField("Password", text: $password)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color1"))
                        
                        SecureField("Password", text: $repeatPassword)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
//                HStack {
//                    Spacer(minLength: 0)
//
//                    Button(action: {}) {
//                        Text("Forget Password?")
//                            .foregroundColor(Color.white.opacity(0.6))
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("background"))
            .clipShape(SignUpCShape())
            .contentShape(SignUpCShape())
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: -2)
            .onTapGesture {
                print("regTap: \(showRegistrationView)")
                index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            Button(action: {
                showRegistrationView.toggle()
                print("regBut: \(showRegistrationView)")
            }) {
                Text("Continue")
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

struct SignUpCShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(index: .constant(1), showRegistrationView: .constant(false))
    }
}
