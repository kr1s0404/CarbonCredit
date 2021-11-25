//
//  IntroView.swift
//  CarbonCredit
//
//  Created by Kris on 11/24/21.
//

import SwiftUI

struct IntroView: View
{
    @State var currentIndex: Int = 0
    
    var body: some View
    {
        ZStack
        {
            DotInversion(currentIndex: $currentIndex)
                .ignoresSafeArea()
        }
    }
}

struct IntroView_Previews: PreviewProvider
{
    static var previews: some View
    {
        IntroView()
    }
}
