//
//  ProfileView.swift
//  CarbonCredit
//
//  Created by Kris on 11/22/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import simd

struct ProfileView: View
{
    @AppStorage("log_status") var log_Status = false
    
    // 使用者選擇用戶大頭貼的變數
    @State var showImagePicker = false
    
    // 用戶大頭貼
    @State var userProfileImage: UIImage?
    
    // 上傳大頭貼到Firebase
    var storageManager = StorageManager()
    
    
    // 用戶UID、email（取得資料的函數在onAppear）
    @State var userName: String =  ""
    @State var nickName: String =  ""
    @State var userImageURL: String = ""
    @State var sw:Bool=false
    
    // 從Firebase上Fetch用戶資料
    @ObservedObject var fetchUserInfo = FetchUserInfo()
    
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
                    Text("用戶姓名: \(userName)")
                    Text("用戶暱稱: \(nickName)")
                    
                    NavigationLink("修改", destination: IntroView())
                    
                    Spacer()
                    Button(action: {
                        storageManager.persistImageToStorage(userProfileImage: userProfileImage)
                    }, label: {
                        Text("儲存資料")
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
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading)
                {
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Text("上傳大頭貼")
                    }
                    .fullScreenCover(isPresented: $showImagePicker) {
                        ImagePicker(image: $userProfileImage)
                            .ignoresSafeArea()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // 降低讀取照片資料大小
            URLCache.shared.memoryCapacity = 1024 * 1024 * 512
            // 取得目前用戶UID、email
            userName = fetchUserInfo.fetchUserName()
            nickName = fetchUserInfo.nickName ?? ""
            print("2.\(userName)")
            print("2.\(nickName)")
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
