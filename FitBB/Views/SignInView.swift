//
//  SignInView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var index: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    VStack(spacing: 10) {
                        Text("Sign In")
                            .foregroundColor(index == 0 ? .black : .gray)
                            .font(.title)
                            .fontWeight(.black)
                        
                        Capsule()
                            .fill(index == 0 ? Color.black : Color.clear)
                            .frame(width: 100, height: 5)
                    }

                    Spacer(minLength: 0)
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
                
                HStack {
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        Text("Forget Password?")
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("background"))
            .clipShape(SignInCShape())
            .contentShape(SignInCShape())
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: -2)
            .onTapGesture {
                index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            Button(action: {}) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("Color1"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(index == 0 ? 1 : 0)
        }
    }
}

struct SignInCShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(index: .constant(0))
    }
}
