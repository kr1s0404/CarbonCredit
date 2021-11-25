//
//  LoginView.swift
//  CarbonCredit
//
//  Created by Kris on 11/22/21.
//

import SwiftUI
import AuthenticationServices
import FirebaseCore

struct LoginView: View
{
    @StateObject var loginData = LoginViewModel()
    
    var body: some View
    {
        ZStack
        {
            // 背景圖片
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
                .overlay(Color.black.opacity(0.3))
                .ignoresSafeArea()
            
            VStack(spacing: 25)
            {
                Spacer()
                Text("碳碳碳權")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.1, alignment: .trailing)
                    .padding(.horizontal)
                Spacer()
                VStack(alignment: .leading, spacing: 30)
                {
                    Text("Carbon\nMarkets\n101")
                        .font(.system(size: 45))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Text("A carbon market allows investors and corporations to trade both carbon credits and carbon offsets simultaneously. This mitigates the environmental crisis, while also creating new market opportunities.")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 1.1)
                .offset(y: -50)
                Spacer()
                
                // 登入按鈕
                SignInWithAppleButton { (request) in
                    loginData.nonce = randomNonceString()
                    request.requestedScopes = [.email, .fullName]
                    request.nonce = sha256(loginData.nonce)
                } onCompletion: { (result) in
                    switch(result)
                    {
                    case .success(let user):
                        print("成功登入")
                        guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                            print("Firebase出現錯誤")
                            return
                        }
                        loginData.authenticate(credential: credential)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 55)
                .clipShape(Capsule())
                .padding(.horizontal, 40)
                .offset(y: -50)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider
{
    static var previews: some View
    {
        LoginView()
        
    }
}
