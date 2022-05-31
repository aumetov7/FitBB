//
//  ProgressBarView.swift
//  FitBB
//
//  Created by Акбар Уметов on 27/5/22.
//

import SwiftUI

struct ProgressBarView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var currentProgress: CGFloat?
    
    var width: CGFloat
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var fcp: CGFloat {
        if currentProgress ?? 0 >= 1 {
            return 1
        } else {
            return currentProgress ?? 0
        }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.orange)
                        .opacity(0.8)
                        .frame(width: width * (2/3),
                               height: 10)
                        .cornerRadius(20, corners: [.bottomLeft, .topLeft])
                        
                    
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.yellow)
                        .opacity(0.8)
                        .frame(width: width * (1/6),
                               height: 10)
                    
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.green)
                        .opacity(0.8)
                        .frame(width: width * (1/6),
                               height: 10)
                        .cornerRadius(20, corners: [.topRight, .bottomRight])
                }
                
                Rectangle()
                    .frame(width: 1, height: 20)
                    .foregroundColor(color)
                    .padding(.leading, width * fcp)
            }
        }
    }
    
    func formattedCurrentProgress(currentProgress: CGFloat) -> CGFloat {
        if currentProgress >= 1 {
            return 1
        } else {
            return CGFloat(currentProgress)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(currentProgress: 325 / 609, width: 300)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

