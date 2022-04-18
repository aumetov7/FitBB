//
//  RegistrationViewFirstPage.swift
//  FitBB
//
//  Created by Акбар Уметов on 14/4/22.
//

import SwiftUI

struct RegistrationViewFirstPage: View {
    @ObservedObject var regViewModel: RegistrationViewModelImpl
    
    @State private var showPassword = false
    @State private var showRepeatPassword = false
    
    @Binding var index: Int
    @Binding var showRegistrationView: Bool
    
    func check(emailAddress: String, firstPassword: String, secondPassword: String) -> Bool {
        let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        
        if (firstPassword == secondPassword) &&
            (!firstPassword.isEmpty || !secondPassword.isEmpty) &&
            password.evaluate(with: firstPassword) &&
            !emailAddress.isEmpty {
            return true
        } else {
            return false
        }
    }
    
//    func textFieldEmailValidation(_ string: String) -> Bool {
//        if string.count > 100 {
//            return false
//        }
//
//        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
//        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
//
//        return emailPredicate.evaluate(with: string)
//    }
    
    var signUpText: some View {
        Button(action: { index = 1 }) {
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
    
    var emailAddressTextField: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color("Color1"))
                
                TextField("Email Address", text: $regViewModel.userDetails.email)
                    .keyboardType(.emailAddress)
            }
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 40)
    }
    
    var passwordTextField: some View {
        VStack {
            HStack(spacing: 15) {
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color("Color1"))
                }
                
                if showPassword {
                    TextField("Password", text: $regViewModel.userDetails.password)
                } else {
                    SecureField("Password", text: $regViewModel.userDetails.password)
                }
            }
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
    
    var repeatPasswordTextField: some View {
        VStack {
            HStack(spacing: 15) {
                Button(action: { showRepeatPassword.toggle() }) {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color("Color1"))
                }
                
                if showRepeatPassword {
                    TextField("Repeat Password", text: $regViewModel.userDetails.repeatPassword)
                } else {
                    SecureField("Repeat Password", text: $regViewModel.userDetails.repeatPassword)
                }
                
                
            }
            
            
            
            Divider().background(Color.white.opacity(0.5))
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
    
    var continueButton: some View {
        Button(action: {
            showRegistrationView.toggle()
            print("pass: \(regViewModel.userDetails.password)")
            print("passRepeat: \(regViewModel.userDetails.repeatPassword)")
        }) {
            Text("Continue")
                .foregroundColor(.white)
                .fontWeight(.black)
                .padding(.vertical)
                .padding(.horizontal, 50)
                .background(check(emailAddress: regViewModel.userDetails.email,
                                  firstPassword: regViewModel.userDetails.repeatPassword,
                                  secondPassword: regViewModel.userDetails.password) ? Color("Color1") : Color.gray)
                .clipShape(Capsule())
                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .disabled(!check(emailAddress: regViewModel.userDetails.email,
                         firstPassword: regViewModel.userDetails.repeatPassword,
                         secondPassword: regViewModel.userDetails.password))
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
                
                emailAddressTextField
                
                passwordTextField
                
                repeatPasswordTextField
                    .padding(.bottom, 22)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("background"))
            .clipShape(SignUpCShape())
            .contentShape(SignUpCShape())
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: -2)
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            continueButton
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

struct RegistrationViewFirstPage_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationViewFirstPage(regViewModel: RegistrationViewModelImpl(service: RegistrationServiceImpl()),
                                  index: .constant(1),
                                  showRegistrationView: .constant(false))
    }
}


    

