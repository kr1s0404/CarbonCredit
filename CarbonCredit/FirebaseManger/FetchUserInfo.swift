//
//  FetchUserInfo.swift
//  CarbonCredit
//
//  Created by Kris on 11/24/21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

struct UserInfo {
    var uid: String
    var email: String
    var userProfileImageURL: String
    var userName: String
    var nickName: String
}

class FetchUserInfo: ObservableObject
{
    
    @Published var userInfo: UserInfo?
    @Published var errorMessage: String?
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    @Published var userName: String?
    @Published var nickName: String?
    
    init ()
    {
        fetchCurrentUser()
        fetchImageURL()
        fetchNickName()
        fetchUserName()
    }
    
    func fetchCurrentUser()
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        
        FirebaseManger.shared.firestore.collection("users").document(uid).getDocument{ snapshot, error in
            if let error = error {
                print("無法讀取當前使用者資訊\n\(error)")
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let userProfileImageURL = data["profileImageURL"] as? String ?? ""
            let userName = data["userName"] as? String ?? ""
            let nickName = data["nickName"] as? String ?? ""
            
            self.userInfo = UserInfo(uid: uid, email: email, userProfileImageURL: userProfileImageURL, userName: userName, nickName: nickName)
            
        }
    }
    
    func fetchImageURL()
    {
        guard image == nil && !isLoading else { return }
        
        guard let fetchURL = URL(string: userInfo?.userProfileImageURL ?? "") else { return }
        isLoading = true
        errorMessage = nil
        
        let request = URLRequest(url: fetchURL, cachePolicy: .returnCacheDataElseLoad)
        
        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let data = data, let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }
        
        task.resume()
    }
    
    func fetchUserUID() -> String
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return "無法獲取uid"}
        return uid
    }
    
    func fetchUserEmail() -> String
    {
        guard let email = FirebaseManger.shared.auth.currentUser?.email else { return "無法獲取email"}
        return email
    }
    
    func fetchUserName()
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        let db = FirebaseManger.shared.firestore
        let ref = db.collection("users").document(uid)
        
        ref.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            self.userName = data["userName"] as? String ?? "尚未建立名稱"
        }
    }
    
    func fetchNickName()
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        let db = FirebaseManger.shared.firestore
        let ref = db.collection("users").document(uid)
        
        ref.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            self.nickName = data["nickName"] as? String ?? "尚未建立暱稱"
        }
    }
    
    func getUserName() -> String
    {
        return userInfo?.userName ?? "no userName"
    }
    
    func getNickName() -> String
    {
        return userInfo?.nickName ?? "no nickName"
    }
}
