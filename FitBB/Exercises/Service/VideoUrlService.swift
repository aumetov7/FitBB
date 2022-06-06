//
//  VideoUrlService.swift
//  FitBB
//
//  Created by Акбар Уметов on 2/5/22.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
//import Combine

protocol VideoUrlService {
    var exercises: [Exercise] { get }
    
    func downloadVideo()
}

final class VideoUrlServiceImpl: ObservableObject, VideoUrlService {
    @Published var exercises: [Exercise] = Exercise.exercises
    
    init() {
        downloadVideo()
    }
    
    func downloadVideo() {
        
        let storageReference = Storage.storage().reference(forURL: firebaseStorageUrl)
        for index in 0 ..< self.exercises.count {
            let storageExerciseReference = storageReference.child("exercises").child(Exercise.exercises[index].videoName + ".mp4")
            
            storageExerciseReference.downloadURL { url, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    guard let videoURl = url?.absoluteString else { return }
                    print("URL: \(videoURl)")
                    DispatchQueue.main.async {
                        self.exercises[index].videoURL = videoURl
                    }
                }
            }
        }
    }
}
