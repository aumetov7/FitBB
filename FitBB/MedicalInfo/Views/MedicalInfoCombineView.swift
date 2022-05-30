//
//  MedicalInfoCombineView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/5/22.
//

import SwiftUI

struct MedicalInfoCombineView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        if sessionService.medicalDetails == nil {
            MedicalInfoChatView()
//                .navigationTitle("Medical Questionnaire")
        } else {
            MedicalInfoView()
//                .navigationTitle("Medical Details")
                .environmentObject(sessionService)
        }
    }
}

struct MedicalInfoCombineView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalInfoCombineView()
            .environmentObject(SessionServiceImpl())
        
        MedicalInfoCombineView()
            .environmentObject(SessionServiceImpl())
            .preferredColorScheme(.dark)
    }
}
