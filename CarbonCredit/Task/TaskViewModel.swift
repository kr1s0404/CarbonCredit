//
//  TaskViewModel.swift
//  CarbonCredit
//
//  Created by Kris on 11/28/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class getTaskData: ObservableObject
{
    @Published var datas = [task]()
    
    init()
    {
        let db = Firestore.firestore()
        
        db.collection("task").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snapshot!.documentChanges
            {
                let id = i.document.documentID
                let name = i.document.get("name") as! String
                let price = i.document.get("price") as! String
                let image = i.document.get("image") as! String
                let status = i.document.get("status") as! String
                
                DispatchQueue.main.async {
                    self.datas.append(task(id: id, name: name, price: price, image: image, status: status))
                }
            }
        }
    }
    
}
