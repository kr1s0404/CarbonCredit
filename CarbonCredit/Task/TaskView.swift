//
//  TaskView.swift
//  CarbonCredit
//
//  Created by Kris on 11/28/21.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import SDWebImageSwiftUI

struct TaskView: View
{
    @State var showTaskCartView: Bool = false
    
    var body: some View
    {
        ZStack
        {
            NavigationView
            {
                TaskHome()
                    .navigationTitle("任務")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showTaskCartView.toggle()
                            }, label: {
                                Image("task")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44, alignment: .trailing)
                            })
                        }
                    }
                
                
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            if showTaskCartView
            {
                GeometryReader { _ in
                    TaskCartView()
                }
                .background(Color.black.opacity(0.55).ignoresSafeArea().onTapGesture {
                    showTaskCartView.toggle()
                })
            }
        }
        .animation(.linear(duration: 0.5))

    }
}

struct TaskHome: View
{
    @ObservedObject var task = getTaskData()
    
    var body: some View
    {
        VStack
        {
            if self.task.datas.count != 0 // 後端任務數量不為零才會顯示
            {
                ScrollView(.vertical, showsIndicators: false)
                {
                    VStack(spacing: 15)
                    {
                        
                        ForEach(self.task.datas) { i in
                            CellView(data: i)
                        }
                    }
                    .padding()
                }
                .background(Color("TaskBG").ignoresSafeArea())
            }
            else
            {
                TaskLoader()
            }
        }
    }
}

struct CellView: View
{
    var data: task
    @State var showTaskDetail: Bool = false
    
    var body: some View
    {
        
        VStack
        {
            AnimatedImage(url: URL(string: data.image)!)
                .resizable()
                .cornerRadius(8)
                .scaledToFit()
                .padding(.horizontal, 18)
                .padding(.top, 15)
                .padding(.bottom, 10)
            
            HStack(spacing: 10)
            {
                VStack(alignment: .leading)
                {
                    Text(data.name)
                        .foregroundColor(.red)
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Text(data.price)
                        .foregroundColor(.red)
                        .font(.body)
                        .fontWeight(.heavy)
                }
                
                Spacer()
                
                Button(action: {
                    showTaskDetail.toggle()
                }, label: {
                    Image(systemName: "arrow.right")
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(10)
                })
                    .background(Color.yellow)
                    .clipShape(Circle())
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 10)
        }
        .background(Color.white)
        .cornerRadius(20)
        .sheet(isPresented: $showTaskDetail) {
            currentTaskView(data: data)
        }
    }
}

struct currentTaskView: View
{
    var data: task
    @State var toggle1: Bool = false
    @State var toggle2: Bool = false
    @State var stepperVar: Int = 0
    @Environment(\.presentationMode) var presentation
    
    var body: some View
    {
        VStack(spacing: 15)
        {
            AnimatedImage(url: URL(string: data.image)!)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            
            VStack(spacing: 20)
            {
                Text(data.name)
                    .fontWeight(.heavy)
                    .font(.title)
                Text(data.price)
                    .fontWeight(.heavy)
                    .font(.body)
                
                Toggle(isOn: $toggle1) { Text("這裡可以放點東西") }
                Toggle(isOn: $toggle2) { Text("這裡可以放點東西") }
                
                Stepper("這裡我不知道要放什麼", value: $stepperVar)
                
                Button(action: {
                    guard let uid = FirebaseManger.shared.auth.currentUser?.uid else { return }
                    let db = Firestore.firestore()
                    db.collection("goinTask").document(uid).collection("onGoinTask").document()
                        .setData(["name": data.name,
                                  "image": data.image,
                                  "price": data.price,
                                  "test1": toggle1,
                                  "test2": toggle2,
                                  "test3": stepperVar]) { (err) in
                            if err != nil
                            {
                                print((err?.localizedDescription)!)
                                return
                            }
                            
                            self.presentation.wrappedValue.dismiss()
                        }
                    
                }, label: {
                    Text("接受任務")
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width / 1.5)
                })
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding()
            
            Spacer()
         }
    }
}

struct TaskView_Previews: PreviewProvider
{
    static var previews: some View
    {
        TaskView()
    }
}

struct TaskLoader: UIViewRepresentable
{
    func makeUIView(context: UIViewRepresentableContext <TaskLoader>) -> UIActivityIndicatorView
    {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext <TaskLoader>)
    {
        
    }
}


