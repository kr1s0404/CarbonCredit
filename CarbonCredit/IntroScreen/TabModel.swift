//
//  TabModel.swift
//  CarbonCredit
//
//  Created by Kris on 11/24/21.
//

import SwiftUI

// Tab Model and sample Intro Tabs....
struct IntroTab: Identifiable{
    var id = UUID().uuidString
    var title: String
    var subTitle: String
    var image: String
    var color: Color
}

// Add more tabs for more intro screens....
var tabs: [IntroTab] = [
    IntroTab(title: "Your name", subTitle: "輸入您的名字", image: "Pic1",color: Color("Green")),
    IntroTab(title: "Your nickname", subTitle: "輸入您的暱稱", image: "Pic2",color: Color("DarkGrey")),
    IntroTab(title: "All Set!", subTitle: "設置完成", image: "Pic3",color: Color("Purple")),
]
