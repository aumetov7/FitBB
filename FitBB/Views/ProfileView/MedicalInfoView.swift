//
//  MedicalInfoView.swift
//  FitBB
//
//  Created by Акбар Уметов on 8/5/22.
//

import SwiftUI

struct MedicalInfoView: View {

    var body: some View {
        MedicalInfoChatView()
            .navigationTitle("Medical Questionnaire")
    }
}

struct MedicalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalInfoView()
    }
}
