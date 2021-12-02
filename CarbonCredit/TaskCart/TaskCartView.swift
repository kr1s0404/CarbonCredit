//
//  taskCartView.swift
//  CarbonCredit
//
//  Created by Kris on 11/29/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct TaskCartView: View
{
    @ObservedObject var taskCartData = getCartData()
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text(taskCartData.datas.count != 0 ? "正在進行中的任務" : "尚無進行中的任務")
                .padding(15)
                .background(Color.black.opacity(0.3))
                .cornerRadius(20)
                .padding([.top, .leading])
                
            
            if taskCartData.datas.count != 0
            {
                List(taskCartData.datas) { i in
                    HStack(spacing: 15)
                    {
                        
                        AnimatedImage(url: URL(string: i.image))
                            .resizable()
                            .frame(width: 55, height: 55)
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading)
                        {
                            Text(i.name)
                            Text(i.price)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height - 350)
        .cornerRadius(25)
        .padding(40)
    }
}

struct TaskCartView_Previews: PreviewProvider
{
    static var previews: some View
    {
        TaskCartView()
    }
}
