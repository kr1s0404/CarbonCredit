//
//  TabBarView.swift
//  CarbonCredit
//
//  Created by Kris on 11/22/21.
//

import SwiftUI

struct TabBarView: View
{
    // 追蹤當前的Tab
    @State var currentTab: Tab = .Home //初始化為進到首頁
    
    // 當前Tab的XValue
    @State var currentXValue: CGFloat = 0
    
    init() {
        // 隱藏原生的Tab Bar
        UITabBar.appearance().isHidden = true
        self._imageLoader = StateObject(wrappedValue: FetchUserInfo())
    }
    
    // Geomtery effect的變數
    @Namespace var animation
    
    
    @StateObject var imageLoader: FetchUserInfo
    
    
    var body: some View
    {
        TabView(selection: $currentTab)
        {
            
            Text("Home")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(Tab.Home)
            
            Text("Task")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(Tab.Task)
            
            Text("Prize")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(Tab.Prize)
            
            ProfileView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(Tab.Profile)
        }
        .overlay(
            
            HStack(spacing: 0)
            {
                
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                }
            }
                .padding(.vertical)
            // 預覽不會顯示SafeArea
                .padding(.bottom, getSafeArea().bottom == 0 ? 10 : (getSafeArea().bottom - 10))
                .background(
                    MaterialEffect(style: .systemUltraThinMaterialDark)
                        .clipShape(ButtonCurveEffectView(currentXValue: currentXValue))
                )
            ,alignment: .bottom
        )
        .ignoresSafeArea(.all, edges: .bottom)
        .preferredColorScheme(.dark) // 黑色模式
    }
    
    // Tab按鈕
    @ViewBuilder
    func TabButton(tab: Tab)->some View {
        
        // Since we need XAxis Value for Curve...
        GeometryReader { proxy in
            Button {
                withAnimation(.spring()) {
                    currentTab = tab
                    // 更新X Value
                    currentXValue = proxy.frame(in: .global).midX
                }
            } label: {
                
                // 當Tab按鈕被點選時要往上移
                
                Image(systemName: tab.rawValue)
                // Since we need perfect value for Curve...
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack
                        {
                            if(currentTab == tab)
                            {
                                MaterialEffect(style: .systemChromeMaterialDark)
                                    .clipShape(Circle())
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            // 設定初始Curve的位子
            .onAppear {
                if tab == Tab.allCases.first && currentXValue == 0 {
                    currentXValue = proxy.frame(in: .global).midX
                }
            }
        }
        .frame(height: 30)
    }
}

// Tab Bar的enum
enum Tab: String, CaseIterable
{
    case Home = "house.fill"
    case Task = "checklist"
    case Prize = "dollarsign.circle.fill" //giftcard
    case Profile = "person.text.rectangle.fill"
}


// 取得不同iPhone的Safe Area
extension View
{
    func getSafeArea() -> UIEdgeInsets
    {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

struct TabBarView_Previews: PreviewProvider
{
    static var previews: some View
    {
        TabBarView()
    }
}
