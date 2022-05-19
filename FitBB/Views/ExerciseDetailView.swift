//
//  ExerciseDetailView.swift
//  FitBB
//
//  Created by Акбар Уметов on 12/4/22.
//

import SwiftUI
import AVKit
import FirebaseStorage

struct ExerciseDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var selectedTab: Int
    
    var index: Int
    
//    var videoStringURL = ""
    
    let videoUrlService = VideoUrlService()
    
    @ViewBuilder
    func video(size: CGSize) -> some View {
        
//        if let url = URL(string: videoUrlService.downloadVideo(for: Exercise.exercises[index].videoName, with: index)) {
//            VideoPlayer(player: AVPlayer(url: url))
//                .frame(height: size.height * 0.25)
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//                .padding(20)
//        } else {
//            Text("Couldn't find \(Exercise.exercises[index].videoName).mp4")
//                .foregroundColor(.red)
//        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HeaderView(selectedTab: $selectedTab, titleText: Exercise.exercises[index].exerciseName)
                    .padding(.bottom)
                
                    Text("\(index)")
                    Spacer()
                    video(size: geometry.size)
                    Spacer()
                    Text("Start button")
                    Text("Raiting")
                
                
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
        .customBackgroundColor(colorScheme: colorScheme)
    }
}

struct ExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailView(selectedTab: .constant(0),
                           index: 0)
        
        ExerciseDetailView(selectedTab: .constant(0),
                           index: 0)
        .preferredColorScheme(.dark)
    }
}
