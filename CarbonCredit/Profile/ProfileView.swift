//
//  ProfileView.swift
//  CarbonCredit
//
//  Created by Kris on 11/22/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ProfileView: View
{
    @AppStorage("log_status") var log_Status = false
    
    // 使用者選擇用戶大頭貼的變數
    @State var showImagePicker = false
    
    // 用戶大頭貼
    @State var userProfileImage: UIImage?
    
    // 上傳大頭貼到Firebase
    var storageManager = StorageManager()
    
    // 從Firebase上Fetch用戶資料
    @StateObject var fetchUserInfo = FetchUserInfo()
    
    // 用戶姓名、暱稱（取得資料的函數在onAppear）
    @State var userName: String = ""
    @State var nickName: String = ""
    
    // 顯示修改個人資料view
    @State var showIntroView: Bool = false
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                /// 用戶大頭貼區塊
                VStack
                {
                    ImageLoadingView()
                }
                .padding()
                
                Spacer()
                
                VStack(spacing: 20)
                {
                    Spacer()
                    Text("成功登入")
                    Spacer()
                    Text("用戶姓名: \(fetchUserInfo.userName ?? "無")")
                    Text("用戶暱稱: \(fetchUserInfo.nickName ?? "無")")
                    
                    
                    Spacer()
                    Button(action: {
                        // 登出
                        DispatchQueue.global(qos: .background).async {
                            try? Auth.auth().signOut()
                        }
                        
                        withAnimation(.easeInOut)
                        {
                            log_Status = false
                        }
                        
                    }, label: {
                        Text("登出")
                            .foregroundColor(.red)
                            .padding(5)
                    })
                    Spacer()
                }
                
            }
            .navigationTitle("個人資料")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .toolbar /// 登出區塊
            {
                ToolbarItemGroup(placement: .navigationBarTrailing)
                {
                    Button(action: {
                        showIntroView.toggle()
                    }) {
                        Text("修改資料")
                    }
                    .sheet(isPresented: $showIntroView) {
                        IntroView()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading)
                {
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Text("上傳照片")
                    }
                    .fullScreenCover(isPresented: $showImagePicker) {
                        ImagePicker(image: $userProfileImage)
                            .ignoresSafeArea()
                            .onDisappear {
                                storageManager.persistImageToStorage(userProfileImage: userProfileImage)
                            }
                    }
                }
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // 降低讀取照片資料大小
            URLCache.shared.memoryCapacity = 1024 * 1024 * 512
            
            
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ProfileView()
    }
}


extension Image
{
    func data(url:URL) -> Self
    {
        if let data = try? Data(contentsOf: url)
        {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}
