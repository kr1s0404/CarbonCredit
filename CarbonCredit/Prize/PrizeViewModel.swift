//
//  PrizeViewModel.swift
//  CarbonCredit
//
//  Created by Kris on 12/2/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class getDoneTaskData: ObservableObject
{
    @Published var datas = [doneTask]()
    
    init()
    {
        guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("doneTask").document(uid).collection("onGoinTask").getDocuments { (snapshot, error) in
            
            if error != nil
            {
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snapshot!.documents
            {
                
                
                
            }
        }
    }
}
