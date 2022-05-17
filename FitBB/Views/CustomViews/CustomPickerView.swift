//
//  CustomPickerView.swift
//  FitBB
//
//  Created by Акбар Уметов on 11/5/22.
//

import SwiftUI
import UIKit

struct CustomPicker: UIViewRepresentable {
    var data: [String]
    @Binding var selectionIndex: Int
    
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 125, height: 200))
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPicker
        
        init(_ pickerView: CustomPicker) {
            self.parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selectionIndex = row
//            parent.saveData = parent.activeData
//            print("\(parent.activeData)")
        }
        
//        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//            return parent.data[row]
//        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 3, height: 30))

            let pickerLabel = UILabel(frame: view.bounds)
            pickerLabel.text = String(parent.data[row])

            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0
            pickerLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)

            view.addSubview(pickerLabel)

            return view
        }
    }
}

