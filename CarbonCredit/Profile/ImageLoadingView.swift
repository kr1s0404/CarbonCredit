//
//  ImageLoadingView.swift
//  CarbonCredit
//
//  Created by Kris on 11/24/21.
//

import SwiftUI

struct ImageLoadingView: View
{
    @StateObject var imageLoader: FetchUserInfo
    
    init()
    {
        self._imageLoader = StateObject(wrappedValue: FetchUserInfo())
    }
    
    var body: some View
    {
        Group
        {
            if imageLoader.userInfo?.userProfileImageURL != nil
            {
                AsyncImage(url: URL(string: imageLoader.userInfo?.userProfileImageURL ?? "")) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFill()
                        .frame(width: 192, height: 192)
                        .cornerRadius(96)
                } placeholder: {
                    ProgressView()
                        .scaledToFill()
                        .frame(width: 192, height: 192)
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 192, height: 192)
            }
        }
        .onAppear {
            imageLoader.fetchImageURL()
        }
        
    }
}

struct ImageLoadingView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ImageLoadingView()
    }
}
