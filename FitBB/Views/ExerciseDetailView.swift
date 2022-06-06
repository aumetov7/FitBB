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
    
    @EnvironmentObject var videoURLService: VideoUrlServiceImpl
    
    @State private var showStartExerciseView = false
    
    @Binding var selectedTab: Int
    
    var index: Int
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HeaderView(selectedTab: $selectedTab, titleText: Exercise.exercises[index].exerciseName)
                    .frame(height: geometry.size.height * 0.15)
                    
                video(size: geometry.size)
                    .frame(width:geometry.size.width, height: geometry.size.height * 0.3)
                    
                RaisedButton(buttonText: "Start") {
                    showStartExerciseView.toggle()
                }
                .frame(height: geometry.size.height * 0.15, alignment: .bottom)
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .frame(width: geometry.size.width)
        }
        .sheet(isPresented: $showStartExerciseView, content: {
            StartExerciseView()
        })
        .customBackgroundColor(colorScheme: colorScheme)
    }
    
    @ViewBuilder
    func video(size: CGSize) -> some View {
        if let url = URL(string: videoURLService.exercises[index].videoURL) {
            VideoPlayer(player: AVPlayer(url: url))
                .frame(height: size.height * 0.25)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(20)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: size.height * 0.25)
                    .foregroundColor(Color("background"))
                    .padding(20)
                
//                Text("Couldn't find \(Exercise.exercises[index].videoName).mp4")
//                    .foregroundColor(.red)
                ProgressView()
            }
        }
    }
}

struct ExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailView(selectedTab: .constant(0),
                           index: 0)
        .environmentObject(VideoUrlServiceImpl())
        
        ExerciseDetailView(selectedTab: .constant(0),
                           index: 0)
        .environmentObject(VideoUrlServiceImpl())
        .preferredColorScheme(.dark)
    }
}
