//
//  ColorSchemeUtilities.swift
//  FitBB
//
//  Created by Акбар Уметов on 7/5/22.
//

import SwiftUI

class ColorSchemeUtilites {
    @AppStorage("selectedAppearance") var selectedAppearance = 1
    var userInterfaceStyle: ColorScheme? = .none
    
    func overrideDisplayMode() {
        var userInterfaseStyle: UIUserInterfaceStyle
        
        if selectedAppearance == 1 {
            userInterfaseStyle = .unspecified
        } else if selectedAppearance == 2 {
            userInterfaseStyle = .light
        } else {
            userInterfaseStyle = .dark
        }
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        
        window.overrideUserInterfaceStyle = userInterfaseStyle
    }
}
