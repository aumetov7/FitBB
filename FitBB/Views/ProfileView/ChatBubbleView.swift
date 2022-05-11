//
//  ChatBubbleView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/5/22.
//

import SwiftUI

struct ChatBubbleView<Content: View>: View {
    let direction: ChatBubbleShape.Direction
    let content: () -> Content
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            content().clipShape(ChatBubbleShape(direction: direction))
            
            if direction == .left {
                Spacer()
            }
        }
        .padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 20)
        .padding((direction == .right) ? .leading : .trailing, 50)
    }
    
    init(direction: ChatBubbleShape.Direction, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.direction = direction
    }
}

struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubbleView(direction: .left) {
            Text("Hello! Im FitBB Helper")
                .padding(.all, 20)
                .foregroundColor(.white)
                .background(Color.blue)
        }
    }
}
