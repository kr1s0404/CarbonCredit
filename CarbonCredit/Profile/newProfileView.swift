//
//  newProfileView.swift
//  CarbonCredit
//
//  Created by Kris on 11/27/21.
//

import SwiftUI
import Firebase

struct newProfileView: View
{
    var body: some View
    {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct newProfileView_Previews: PreviewProvider
{
    static var previews: some View
    {
        newProfileView()
    }
}

struct Home: View
{
    @AppStorage("log_status") var log_Status = false
    
    // 顯示修改個人資料view
    @State var showIntroView: Bool = false
    
    // 從Firebase上Fetch用戶資料
    @StateObject var fetchUserInfo = FetchUserInfo()
    
    // 使用者選擇用戶大頭貼的變數
    @State var showImagePicker = false
    
    // 用戶大頭貼
    @State var userProfileImage: UIImage?
    
    // 上傳大頭貼到Firebase
    var storageManager = StorageManager()
    
    var body: some View
    {
        GeometryReader { _ in
            VStack
            {
                ImageLoadingView()
                    .frame(width: 192, height: 192, alignment: .center)
                    .padding()
                
                ZStack(alignment: .bottom)
                {
                    
                    VStack
                    {
                        HStack ///上傳照片按鈕要放的位置
                        {
                            Text("個人資料")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.top, 30)
                        
                        VStack /// 用戶名稱的位置
                        {
                            HStack(spacing: 15)
                            {
                                Image(systemName: "signature")
                                    .foregroundColor(Color("Color3"))
                                
                                Text(fetchUserInfo.userName ?? "用戶名稱")
                            }
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        VStack /// 用戶暱稱的位置
                        {
                            HStack(spacing: 15)
                            {
                                Image(systemName: "highlighter")
                                    .foregroundColor(Color("Color3"))
                                
                                Text(fetchUserInfo.nickName ?? "用戶暱稱")
                                
                            }
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        HStack /// 修改個人資料view
                        {
                            Spacer(minLength: 0)
                            Button(action: {
                                showIntroView.toggle()
                            }) {
                                Text("修改資料")
                                    .foregroundColor(.blue.opacity(0.6))
                            }
                            .sheet(isPresented: $showIntroView) {
                                IntroView()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                    }
                    .padding()
                    .padding(.bottom, 40)
                    .background(Color("Color1"))
                    .cornerRadius(35)
                    .padding(.horizontal, 20)
                    
                    
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Text("上傳照片")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal, 50)
                            .background(Color("Color3"))
                            .clipShape(Capsule())
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .fullScreenCover(isPresented: $showImagePicker) {
                        ImagePicker(image: $userProfileImage)
                            .ignoresSafeArea()
                            .onDisappear {
                                storageManager.persistImageToStorage(userProfileImage: userProfileImage)
                            }
                    }
                        .offset(y: 25) // 按鈕下移
                }
                
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
                    .offset(y: 60)
            }
        }
        .background(Color("Color2").edgesIgnoringSafeArea(.all))
    }
}
