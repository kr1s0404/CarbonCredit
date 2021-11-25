//
//  StorageManger.swift
//  CarbonCredit
//
//  Created by Kris on 11/23/21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

public class StorageManager: ObservableObject
{
    var firestoreManger = FirestoreManager()
    
    func persistImageToStorage(userProfileImage: UIImage?)
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        guard let imageData = userProfileImage?.jpegData(compressionQuality: 0.5) else { return }
        let ref = FirebaseManger.shared.storage.reference(withPath: uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // 上傳照片
        ref.putData(imageData, metadata: metadata) { metadata, err in
            if let err = err {
                print("無法儲存圖片 \(err)")
                return
            }
            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
        }
        
        
        
        ref.downloadURL { url, err in
            if let err = err {
                print("無法獲取圖片 \(err)")
                return
            }
            
            guard let url = url else { return }
            self.firestoreManger.storeUserInfo(profileImageURL: url)
            print("圖片網址 \(url)")
        }
        
        
    }
    
    func showUserID() -> String
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return "fail to get user ID" }
        return uid
    }
    
    func showUserEmail() -> String
    {
        guard let email = FirebaseManger.shared.auth.currentUser?.email else { return "fail to get user Email"}
        return email
    }
}
