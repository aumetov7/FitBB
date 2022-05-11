//
//  PickerField.swift
//  FitBB
//
//  Created by Акбар Уметов on 8/5/22.
//

import SwiftUI

struct PickerField: UIViewRepresentable {
    @Binding var selectionIndex: Int?
    
    private var placeholder: String
    private var data: [String]
    private var textField: PickerTextField
    
    init<S>(_ title: S, data: [String], selectionIndex: Binding<Int?>) where S: StringProtocol {
        self.placeholder = String(title)
        self.data = data
        self._selectionIndex = selectionIndex
        
        textField = PickerTextField(data: data, selectionIndex: selectionIndex)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PickerField>) -> UITextField {
        textField.placeholder = placeholder
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PickerField>) {
        if let index = selectionIndex {
            uiView.text = data[index]
        } else {
            uiView.text = ""
        }
    }
}
