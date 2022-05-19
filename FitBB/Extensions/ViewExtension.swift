//
//  ViewExtension.swift
//  FitBB
//
//  Created by Акбар Уметов on 7/5/22.
//

import Foundation
import SwiftUI

extension View {
    func halfSheet<SheetView: View> (showSheet: Binding<Bool>,
                                     @ViewBuilder sheetView: @escaping () -> SheetView,
                                     onEnd: @escaping () -> ()) -> some View {
        
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), onEnd: onEnd, showSheet: showSheet)
            )
    }
    
    func customBackgroundColor(colorScheme: ColorScheme) -> some View {
        self
            .background(colorScheme == .dark ? Color("Color2") : Color.white)
    }
}
