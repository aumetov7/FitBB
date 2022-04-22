//
//  ImageExtension.swift
//  FitBB
//
//  Created by Акбар Уметов on 21/4/22.
//

import SwiftUI

extension Image {
    func resizedToFill(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
    }
}
