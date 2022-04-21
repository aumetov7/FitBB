//
//  ProfileView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/4/22.
//

import SwiftUI

struct ProfileView: View {
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("background"))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    Button(action: {
                        sessionService.logout()
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.backward.circle")
                                .font(.headline)
                            Text("Logout")
                                .fontWeight(.medium)
                        }
                    })
                    .buttonStyle(EmbossedButtonStyle())
                    .padding(.trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 25)
                
                Text("Welcome")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.heavy)
                    .kerning(0.7)
                
                
                Text("\(sessionService.userDetails?.firstName ?? "N/A")")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .kerning(0.7)
                    .padding(.bottom, 100)
                
                
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        ZStack {
                            Circle()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.white)
                            
                            Text("""
                                Choose profile
                                photo
                                """)
                            .multilineTextAlignment(.center)
                            
                        }
                        
                        image?
                            .resizedToFill(width: 150, height: 150)
                            .clipShape(Circle())
                    }
                    
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
                .padding(.bottom, 50)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Birth Date: \(sessionService.userDetails?.dateOfBirth ?? "N/A")")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .kerning(0.5)
                    
                    Text("Gender: \(sessionService.userDetails?.gender ?? "N/A")")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .kerning(0.5)
                    
                    Text("Goal: \(sessionService.userDetails?.goal ?? "N/A")")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .kerning(0.5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .onChange(of: inputImage) { newImage in
                loadImage()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
            }
        }
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
    }
}
