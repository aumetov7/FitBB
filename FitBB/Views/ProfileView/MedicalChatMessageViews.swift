//
//  MedicalChatMessageViews.swift
//  FitBB
//
//  Created by Акбар Уметов on 11/5/22.
//

import SwiftUI

struct WelcomeTextView: View {
    var welcomeText = "Hello! I'm FitBB helper. I want you to spend a few minutes to complete the medical questionnaire. This will help me more accurately create a workout and nutrition plan for you. If you are ready, please push the Start button!"
    
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(welcomeText)
                .chatBubbleText()
        }
    }
}

struct StartTextView: View {
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    
    var startText = "Lets start!"
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            Text(startText)
                .chatBubbleText()
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
}

struct BloodPressureTextView: View {
    @Binding var showBloodPressurePicker: Bool
    @Binding var showSendButton: Bool
    @Binding var showTypingText: Bool
    
    var bloodPressureText = "I'm very happy to talk about your health! Can you tell me do you have a problems with Blood Pressure?"
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(bloodPressureText)
                .chatBubbleText()
        }
        .onAppear {
            showTypingText.toggle()
            showSendButton.toggle()
            showBloodPressurePicker.toggle()
        }
    }
}

struct BloodPressureAnswerView: View {
    @Binding var bloodPressure: String
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            Text("I have a \(bloodPressure) blood pressure")
                .chatBubbleText()
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
}

struct EyesTextView: View {
    @Binding var showBloodPressurePicker: Bool
    @Binding var showEyesPicker: Bool
    @Binding var showTypingText: Bool
    
    var eyesText = "Okie! I will remember it. Lets talk about your eyes. Do you have a problem with your Eyes?"
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(eyesText)
                .chatBubbleText()
        }
        .onAppear {
            showBloodPressurePicker.toggle()
            showEyesPicker.toggle()
            showTypingText.toggle()
        }
    }
}

struct EyesAnswerView: View {
    @Binding var eyes: String
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            if eyes == "normal" {
                Text("I don't have a problems with eyes")
                    .chatBubbleText()
            } else {
                Text("I have a problems with eyes")
                    .chatBubbleText()
            }
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
}

struct SpineTextView: View {
    @Binding var eyes: String
    @Binding var showSpinePicker: Bool
    @Binding var showEyesPicker: Bool
    @Binding var showTypingText: Bool
    
    var normalText = "Thats great! What about your spine? Do you have some problems with it?"
    var haveProblemsText = "Okay. I have a good memory :) What about your spine? Do you have some problems with it?"
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            if eyes == "normal" {
                Text(normalText)
                    .chatBubbleText()
            } else {
                Text(haveProblemsText)
                    .chatBubbleText()
            }
        }
        .onAppear {
            showEyesPicker.toggle()
            showSpinePicker.toggle()
            showTypingText.toggle()
        }
    }
}

struct SpineAnswerView: View {
    @Binding var spine: String
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            if spine == "normal" {
                Text("I don't have a problems with spine")
                    .chatBubbleText()
            } else {
                Text("I have a \(spine)")
                    .chatBubbleText()
            }
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
}

struct SpinePartTextView: View {
    @Binding var spine: String
    @Binding var showSpinePicker: Bool
    @Binding var showSpinePartPicker: Bool
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 2
    }
    
    var body: some View {
        if spine == "normal" {
            ChatBubbleView(direction: .left) {
                Text("Cool! Go to the next question!")
                    .chatBubbleText()
            }
            .task(nextMessage)
            .onAppear {
                showTypingText.toggle()
            }
        } else {
            ChatBubbleView(direction: .left) {
                Text("Okay. In which part of your spine you have a \(spine)?")
                    .chatBubbleText()
            }
            .onAppear {
                showSpinePicker.toggle()
                showSpinePartPicker.toggle()
                showTypingText.toggle()
            }
        }
    }
}

struct SpinePartAnswerView: View {
    @Binding var spine: String
    @Binding var spinePartSelectedIndex: Int
    @Binding var spinePartArray: [String]
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        if spine == "normal" {
            EmptyView()
                .task(nextMessage)
        } else {
            ChatBubbleView(direction: .right) {
                Text("The \(spine) in \(spinePartArray[spinePartSelectedIndex]) part")
                    .chatBubbleText()
            }
            .task(nextMessage)
            .onAppear {
                showTypingText.toggle()
            }
        }
    }
}

struct HeartTextView: View {
    @Binding var spine: String
    @Binding var messages: Int
    
    var normalText = "I hope that you are not tired. Please, stay there. It's very important. We are about to finish!"
    var haveProblemText = "Don't worry! I will create a workout plan without any danger for your health! "
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            if spine == "normal" {
                Text(normalText)
                    .chatBubbleText()
            } else {
                Text(haveProblemText)
                    .chatBubbleText()
            }
        }
        .task(nextMessage)
    }
}

struct HeartTextSecondView: View {
    @Binding var spine: String
    @Binding var showSpinePartPicker: Bool
    @Binding var showHeartPicker: Bool
    @Binding var showTypingText: Bool
    
    var normalText = "Do you have some problems with heart?"
    var haveProblemText = "I hope that you are not tired. Please, stay there. It's very important. We are about to finish! Do you have some problems with heart?"
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            if spine == "normal" {
                Text(normalText)
                    .chatBubbleText()
            } else {
                Text(haveProblemText)
                    .chatBubbleText()
            }
        }
        .onAppear {
            showSpinePartPicker.toggle()
            showHeartPicker.toggle()
            showTypingText.toggle()
        }
        
    }
}

struct HeartAnswerView: View {
    @Binding var heartArray: [String]
    @Binding var heartSelectedIndex: Int
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            if heartArray[heartSelectedIndex] == "don't have" {
                Text("I don't have problems with heart")
                    .chatBubbleText()
            } else {
                Text("I have \(heartArray[heartSelectedIndex])")
                    .chatBubbleText()
            }
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
}

struct JointsAndLigamentsTextView: View {
    @Binding var heartArray: [String]
    @Binding var heartSelectedIndex: Int
    @Binding var showHeartPicker: Bool
    @Binding var showJointsAndLigamentsPicker: Bool
    @Binding var showTypingText: Bool
    
    var normalText = "Awesome! And the last one question. If you have problems with joints or ligaments, please choose the part of your body"
    var haveProblemText = "Okay. I will pay attention on it! And the last one question. If you have problems with joints or ligaments, please choose the part of your body"
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            if heartArray[heartSelectedIndex] == "don't have" {
                Text(normalText)
                    .chatBubbleText()
            } else {
                Text(haveProblemText)
                    .chatBubbleText()
            }
        }
        .onAppear {
            showHeartPicker.toggle()
            showJointsAndLigamentsPicker.toggle()
            showTypingText.toggle()
        }
    }
}

struct JointsAndLigamentsAnswerView: View {
    @Binding var jointsAndLigamentsArray: [String]
    @Binding var jointsAndLigamentsSelectedIndex: Int
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            if jointsAndLigamentsArray[jointsAndLigamentsSelectedIndex] == "don't have" {
                Text("I don't have problems with Joints and Ligaments")
                    .chatBubbleText()
            } else {
                Text("I have some problems with \(jointsAndLigamentsArray[jointsAndLigamentsSelectedIndex])")
                    .chatBubbleText()
            }
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
}

struct FinishTheQuestionaireView: View {
    @Binding var showJointsAndLigamentsPicker: Bool
    @Binding var showSendButton: Bool
    @Binding var showTypingText: Bool
    @Binding var showMessagePart: Bool
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text("Yay! Thank you for answers. Now I can create a workout plan for you using the information from this Medical Questionaire! See you!")
                .chatBubbleText()
        }
        .onAppear {
            showJointsAndLigamentsPicker.toggle()
            showSendButton.toggle()
            showTypingText.toggle()
            showMessagePart.toggle()
        }
    }
}
