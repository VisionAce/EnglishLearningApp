//
//  ChatViewModel.swift
//  ChatGptApp
//
//  Created by 褚宣德 on 2023/5/19.
//

import Foundation
extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []//空的Arry中可透過Message中的content來限制ChatGpt每次的回話。例如： Message(id: UUID(), role: .system此元素會根據模型的不同而不同, content: "以文字敘述的限制條件", creatAt: Date())
        @Published var currentInput: String = "請隨機生成10個常用的簡單難度的英文單字，headers：單字、詞性、中文解釋、例句，請將結果以json格式輸出"
        
        private let openAIService = OpenAIService()
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, creatAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task{
                let response = await openAIService.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    return
                }
            
                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, creatAt: Date())
                await MainActor.run{
                    messages.append(receivedMessage)
                    print(receivedOpenAIMessage.content)
                }
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let creatAt: Date
}
