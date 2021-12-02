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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View
    {
        ZStack
        {
            DotInversion(currentIndex: $currentIndex)
                .ignoresSafeArea()
        
            if(currentIndex == 2)
            {
                Button("完成") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                
            }
        }
        .onTapGesture {
            self.dissmissKeyboard()
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
