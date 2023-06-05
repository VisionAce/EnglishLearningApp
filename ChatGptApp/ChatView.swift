//
//  ContentView.swift
//  ChatGptApp
//
//  Created by 褚宣德 on 2023/5/19.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollView{
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                 messageView(message: message)
                }
            }
            HStack{
                TextField("輸入訊息...",text: $viewModel.currentInput)
                Button{
                    viewModel.sendMessage()
                } label: {
                    Text("送出")
                        .foregroundColor(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
    
    func messageView(message: Message) -> some View {
        HStack{
            if message.role == .user {Spacer()}
            Text(message.content)
                .foregroundColor(message.role == .user ? .white : .black)
                .padding()// 默認為四個邊缘添加相同的内邊距
                .background(message.role == .user ? .blue : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.role == .assistant {Spacer()}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
