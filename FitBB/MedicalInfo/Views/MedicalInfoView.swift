//
//  MedicalInfoView.swift
//  FitBB
//
//  Created by Акбар Уметов on 8/5/22.
//

import SwiftUI

struct MedicalInfoView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Personal Details")
                    .titleText()
                    .frame(height: geometry.size.height * 0.1, alignment: .top)
                    .padding(.horizontal)
                
                profileImage
                    .frame(height: geometry.size.height * 0.2, alignment: .top)
                
                LazyVStack(spacing: 10) {
                    Group {
                        personalDetails(text: "First Name",
                                        value: "\(sessionService.userDetails?.firstName ?? "N/A")")
                        personalDetails(text: "Date of birth",
                                        value: "\(sessionService.userDetails?.dateOfBirth ?? "N/A")")
                        personalDetails(text: "Gender",
                                        value: "\(sessionService.userDetails?.gender ?? "N/A")")
                    }
                    Divider()
                        .padding(.horizontal)
                    Group {
                        personalDetails(text: "Weight",
                                        value: "\(sessionService.medicalDetails?.weight ?? "N/A")")
                        personalDetails(text: "Height",
                                        value: "\(sessionService.medicalDetails?.height ?? "N/A")")
                        personalDetails(text: "Blood pressure",
                                        value: "\(sessionService.medicalDetails?.bloodPressure ?? "N/A")")
                        personalDetails(text: "Eyes",
                                        value: "\(sessionService.medicalDetails?.eyes ?? "N/A")")
                        personalDetails(text: "Spine",
                                        value: "\(sessionService.medicalDetails?.spine ?? "N/A")")
                        if sessionService.medicalDetails?.spine == "hernia" || sessionService.medicalDetails?.spine == "protrusion" {
                        personalDetails(text: "Spine Part",
                                        value: "\(spinePartArray[sessionService.medicalDetails?.spinePartSelectedIndex ?? 0])")
                        }
                        personalDetails(text: "Heart",
                                        value: "\(heartArray[sessionService.medicalDetails?.heartSelectedIndex ?? 0])")
                        personalDetails(text: "Joints and ligaments",
                                        value: "\(jointsAndLigamentsArray[sessionService.medicalDetails?.jointsAndLigamentsSelectedIndex ?? 0])")
                    }
                }
                .frame(height: geometry.size.height * 0.6, alignment: .top)
                .padding(.horizontal)
            }
            .frame(height: geometry.size.height)
        }
        .customBackgroundColor(colorScheme: colorScheme)
    }
    
    @ViewBuilder
    func personalDetails(text: String, value: String) -> some View {
        HStack {
            Text(text)
                .makeRound()
            Text(value)
                .signText()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
    }
    
    var profileImage: some View {
        AsyncImage(url: URL(string: sessionService.userDetails?.profileImage ?? "")) { image in
            image
                .resizedToFill(width: 150, height: 150)
                .clipShape(Circle())
        } placeholder: {
            ZStack {
                Circle()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray.opacity(0.15))
                
                ProgressView()
            }
        }
    }
}

struct MedicalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalInfoView()
            .environmentObject(SessionServiceImpl())
        
        MedicalInfoView()
            .environmentObject(SessionServiceImpl())
            .preferredColorScheme(.dark)
    }
}
