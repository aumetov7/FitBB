//
//  PickerView.swift
//  FitBB
//
//  Created by Акбар Уметов on 13/4/22.
//

import SwiftUI

struct PickerView: View {
    @State private var currentGender = "Any"
    var genderArray = ["Male", "Female", "Any"]

        var body: some View {
            
            Picker("Gender", selection: $currentGender) {
                ForEach(genderArray, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)

        }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
