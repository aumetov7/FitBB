//
//  HeaderView.swift
//  FitBB
//
//  Created by Акбар Уметов on 12/4/22.
//

import SwiftUI

struct HeaderView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var selectedTab: Int
    
    let titleText: String
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        VStack {
            Text(titleText)
                .roundedTitle(alignment: .center, padding: .top)
            
            HStack {
                ForEach(0 ..< Exercise.exercises.count, id: \.self) { index in
                    ZStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(color)
                            .opacity(index == selectedTab ? 0.5 : 0)
                        
                        Circle()
                            .frame(width: 16, height: 16)
                            .foregroundColor(color)
                    }
                    .onTapGesture {
                        selectedTab = index
                    }
                }
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(selectedTab: .constant(0),
                   titleText: Exercise.exercises[0].exerciseName)
        .previewLayout(.sizeThatFits)
        
        HeaderView(selectedTab: .constant(0),
                   titleText: Exercise.exercises[0].exerciseName)
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
