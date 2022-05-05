//
//  VideoUrlService.swift
//  FitBB
//
//  Created by Акбар Уметов on 2/5/22.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class VideoUrlService {
    func downloadVideo(with index: Int, completion: @escaping ((String) -> Void)) {
        let storageReference = Storage.storage().reference(forURL: firebaseStorageUrl)
        let storageExerciseReference = storageReference.child("exercises").child(Exercise.exercises[index].videoName + ".mp4")

        storageExerciseReference.downloadURL { url, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                guard let videoURl = url?.absoluteString else { return }

                completion(videoURl)
            }
        }
    }
}
