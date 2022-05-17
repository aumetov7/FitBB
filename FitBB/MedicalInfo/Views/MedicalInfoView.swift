//
//  MedicalInfoView.swift
//  FitBB
//
//  Created by Акбар Уметов on 8/5/22.
//

import SwiftUI

struct MedicalInfoView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weight: \(sessionService.medicalDetails?.weight ?? "N/A")")
                .makeRound()
            Text("Height: \(sessionService.medicalDetails?.height ?? "N/A")")
                .makeRound()
            Text("Blood pressure: \(sessionService.medicalDetails?.bloodPressure ?? "N/A")")
                .makeRound()
            Text("Eyes: \(sessionService.medicalDetails?.eyes ?? "N/A")")
                .makeRound()
            Text("Spine: \(sessionService.medicalDetails?.spine ?? "N/A")")
                .makeRound()
            if sessionService.medicalDetails?.spine == "hernia" || sessionService.medicalDetails?.spine == "protrusion" {
                Text("Spine Part: \(spinePartArray[sessionService.medicalDetails?.spinePartSelectedIndex ?? 0])")
                    .makeRound()
            }
            Text("Heart: \(heartArray[sessionService.medicalDetails?.heartSelectedIndex ?? 0])")
                .makeRound()
            Text("Joints and Ligaments: \(jointsAndLigamentsArray[sessionService.medicalDetails?.jointsAndLigamentsSelectedIndex ?? 0])")
                .makeRound()
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.leading)
    }
}

struct MedicalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalInfoView()
            .environmentObject(SessionServiceImpl())
    }
}
