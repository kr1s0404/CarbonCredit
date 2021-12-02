//
//  TaskCartViewModel.swift
//  CarbonCredit
//
//  Created by Kris on 11/29/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class getCartData: ObservableObject
{
    @Published var datas = [taskCart]()
    
    init()
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("goinTask").document(uid).collection("onGoinTask").getDocuments { (snapshot, error) in
            
            if error != nil
            {
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snapshot!.documents
            {
                let id = i.documentID
                let name = i.get("name") as! String
                let image = i.get("image") as! String
                let price = i.get("price") as! String
                let status = i.get("status") as! String
                
                DispatchQueue.main.async {
                    self.datas.append(taskCart(id: id, name: name, image: image, price: price, status: status))
                }
            }
        }
    }
}
