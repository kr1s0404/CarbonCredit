//
//  NewsView.swift
//  CarbonCredit
//
//  Created by Kris on 11/27/21.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct NewsView: View
{
    @ObservedObject var list = getDataFromMedium()
    
    var body: some View
    {
        NavigationView
        {
            List(list.datas) { i in
                
                NavigationLink(destination: webView(url: i.url), label: {
                    HStack
                    {
                        VStack(alignment: .leading, spacing: 10)
                        {
                            Text(i.title)
                                .font(.system(size: 50))
                                .fontWeight(.heavy)
                                .lineLimit(3)
                            
                            Text(i.desc)
                                .font(.body)
                                .lineLimit(2)
                            
                            if i.image != ""
                            {
                                WebImage(url: URL(string: i.image)!, options: .highPriority, context: nil)
                                    .resizable()
                                    .cornerRadius(10)
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }
                        
                        
                    }
                    .padding(.vertical, 15)
                })
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationTitle("News 新聞")
            
        }
        .animation(.easeInOut)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NewsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NewsView()
    }
}

struct webView: UIViewRepresentable
{
    var url: String
    
    func makeUIView(context: UIViewRepresentableContext <webView>) -> WKWebView {
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext <webView>) {
        
    }
}
