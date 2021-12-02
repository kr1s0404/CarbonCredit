//
//  FirestoreManger.swift
//  CarbonCredit
//
//  Created by Kris on 11/23/21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

public class FirestoreManager: ObservableObject
{
    var fetch = FetchUserInfo()
    
    func storeUserInfo(profileImageURL: URL)
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        guard let email = FirebaseManger.shared.auth.currentUser?.email else { return }
        let userName = fetch.userName ?? "尚未建立名稱"
        let nickName = fetch.nickName ?? "尚未建立暱稱"
        let userData = ["email": email, "uid": uid, "profileImageURL": profileImageURL.absoluteString, "userName": userName, "nickName": nickName]
        
        FirebaseManger.shared.firestore.collection("users")
            .document(uid)
            .setData(userData, completion: { err in
                if let err = err {
                    print(err)
                    return
                }
                print("\n成功儲存用戶資訊\n")
            })
    }
    
    func addUserName(userName: String)
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        let dataBase = FirebaseManger.shared.firestore
        let ref = dataBase.collection("users").document(uid)
        
        ref.updateData(["userName": userName])
    }
    
    func addNickName(nickName: String)
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        let dataBase = FirebaseManger.shared.firestore
        let ref = dataBase.collection("users").document(uid)
        
        ref.updateData(["nickName": nickName])
    }
    
}
