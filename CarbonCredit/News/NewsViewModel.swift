//
//  NewsViewModel.swift
//  CarbonCredit
//
//  Created by Kris on 11/29/21.
//

import SwiftUI
import FirebaseFirestore
import SwiftyJSON

class getDataFromAPI: ObservableObject
{
    @Published var datas = [dataTypeForAPI]()
    
    init()
    {
        let source = "https://newsapi.org/v2/top-headlines?country=tw&apiKey=4fdb24e0eead4566b614b0366df6796a"
        let url = URL(string: source)!
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSON(data: data!)
            for i in json["articles"] {
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                DispatchQueue.main.async {
                    self.datas.append(dataTypeForAPI(id: id, title: title, desc: description, url: url, image: image))
                }
            }
        }
        .resume()
        
    }
}

class getDataFromMedium: ObservableObject
{
    @Published var datas = [dataTypeForMedium]()
    
    init()
    {
        let db = Firestore.firestore()
        
        db.collection("news").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            
            for i in snapshot!.documentChanges
            {
                let id = i.document.documentID
                let title = i.document.get("title") as! String
                let description = i.document.get("description") as! String
                let image = i.document.get("image") as! String
                let author = i.document.get("author") as! String
                let url = i.document.get("url") as! String
                
                DispatchQueue.main.async {
                    self.datas.append(dataTypeForMedium(id: id, author: author, title: title, desc: description, url: url, image: image))
                }
            }
        }
        
    }
}
