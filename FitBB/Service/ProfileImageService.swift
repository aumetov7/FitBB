//
//  ProfileImageService.swift
//  FitBB
//
//  Created by Акбар Уметов on 30/4/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileImageService: ObservableObject {
    func updateProfileImage(with image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        let storageReference = Storage.storage().reference(forURL: firebaseStorageUrl)
        let storageProfileReference = storageReference.child("profile").child(uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        storageProfileReference.putData(imageData, metadata: metadata) { storageMetadata, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            storageProfileReference.downloadURL { url, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    guard let imageUrl = url?.absoluteString else { return }
                    print("Image URL: \(imageUrl)")
                    let profileImageValue = [RegistrationKeys.profileImage.rawValue: imageUrl] as [String: Any]
                    Database.database().reference().child("users").child(uid).updateChildValues(profileImageValue)
                }
            }
        }
    }
}
