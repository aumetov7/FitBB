//
//  MedicalChatMessageViews.swift
//  FitBB
//
//  Created by Акбар Уметов on 11/5/22.
//

import SwiftUI

struct WelcomeTextView: View {
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(medicalQuestionnaireWelcomeText)
                .chatBubbleText()
        }
    }
}

struct StartTextView: View {
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            Text(medicalQuestionnaireStartText)
                .chatBubbleText()
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
}

struct WeightTextView: View {
    @Binding var showTypingText: Bool
    @Binding var showSendButton: Bool
    @Binding var showWeightTextField: Bool
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(medicalQuestionnaireWeightText)
                .chatBubbleText()
        }
        .onAppear {
            showTypingText.toggle()
            showSendButton.toggle()
            showWeightTextField.toggle()
        }
    }
}

struct WeightAnswerView: View {
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var showTypingText: Bool
    @Binding var messages: Int
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            Text("My weight is \(medicalInfoViewModel.medicalDetails.weight) kg")
                .chatBubbleText()
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
}

struct HeightTextView: View {
    @Binding var showTypingText: Bool
    @Binding var showWeightTextField: Bool
    @Binding var showHeightTextField: Bool
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(medicalQuestionnaireHeightText)
                .chatBubbleText()
        }
        .onAppear {
            showTypingText.toggle()
            showWeightTextField.toggle()
            showHeightTextField.toggle()
        }
    }
}

struct HeightAnswerView: View {
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var showTypingText: Bool
    @Binding var messages: Int
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            Text("My height is \(medicalInfoViewModel.medicalDetails.height) cm")
                .chatBubbleText()
        }
        .task(nextMessage)
        .onAppear {
            showTypingText.toggle()
        }
    }
    
}

struct BloodPressureTextView: View {
    @Binding var showHeightTextField: Bool
    @Binding var showBloodPressurePicker: Bool
    @Binding var showTypingText: Bool
    
    
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(medicalQuestionnaireBloodPressureText)
                .chatBubbleText()
        }
        .onAppear {
            showTypingText.toggle()
            showHeightTextField.toggle()
            showBloodPressurePicker.toggle()
        }
    }
}

struct BloodPressureAnswerView: View {
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            Text("I have a \(medicalInfoViewModel.medicalDetails.bloodPressure) blood pressure")
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
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(medicalQuestionnaireEyesText)
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            if medicalInfoViewModel.medicalDetails.eyes == "normal" {
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var showSpinePicker: Bool
    @Binding var showEyesPicker: Bool
    @Binding var showTypingText: Bool
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            if medicalInfoViewModel.medicalDetails.eyes == "normal" {
                Text(medicalQuestionnaireSpineNormalText)
                    .chatBubbleText()
            } else {
                Text(medicalQuestionnaireSpineHaveProblemsText)
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            if medicalInfoViewModel.medicalDetails.spine == "normal" {
                Text("I don't have a problems with spine")
                    .chatBubbleText()
            } else {
                Text("I have a \(medicalInfoViewModel.medicalDetails.spine)")
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var showSpinePicker: Bool
    @Binding var showSpinePartPicker: Bool
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 2
    }
    
    var body: some View {
        if medicalInfoViewModel.medicalDetails.spine == "normal" {
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
                Text("Okay. In which part of your spine you have a \(medicalInfoViewModel.medicalDetails.spine)?")
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        if medicalInfoViewModel.medicalDetails.spine == "normal" {
            EmptyView()
                .task(nextMessage)
        } else {
            ChatBubbleView(direction: .right) {
                Text("The \(medicalInfoViewModel.medicalDetails.spine) in \(spinePartArray[medicalInfoViewModel.medicalDetails.spinePartSelectedIndex]) part")
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var messages: Int
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            if medicalInfoViewModel.medicalDetails.spine == "normal" {
                Text(medicalQuestionnaireHeartNormalText)
                    .chatBubbleText()
            } else {
                Text(medicalQuestionnaireHeartHaveProblemText)
                    .chatBubbleText()
            }
        }
        .task(nextMessage)
    }
}

struct HeartTextSecondView: View {
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var showSpinePartPicker: Bool
    @Binding var showHeartPicker: Bool
    @Binding var showTypingText: Bool
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            if medicalInfoViewModel.medicalDetails.spine == "normal" {
                Text(medicalQuestionnaireHeartDiseaseNormalText)
                    .chatBubbleText()
            } else {
                Text(medicalQuestionnaireHeartDiseaseHaveProblemText)
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            if heartArray[medicalInfoViewModel.medicalDetails.heartSelectedIndex] == "don't have" {
                Text("I don't have problems with heart")
                    .chatBubbleText()
            } else {
                Text("I have \(heartArray[medicalInfoViewModel.medicalDetails.heartSelectedIndex])")
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var showHeartPicker: Bool
    @Binding var showJointsAndLigamentsPicker: Bool
    @Binding var showTypingText: Bool
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            if heartArray[medicalInfoViewModel.medicalDetails.heartSelectedIndex] == "don't have" {
                Text(medicalQuestionnaireJLNormalText)
                    .chatBubbleText()
            } else {
                Text(medicalQuestionnaireJLHaveProblemText)
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    @Binding var messages: Int
    @Binding var showTypingText: Bool
    
    @Sendable private func nextMessage() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        messages += 1
    }
    
    var body: some View {
        ChatBubbleView(direction: .right) {
            if jointsAndLigamentsArray[medicalInfoViewModel.medicalDetails.jointsAndLigamentsSelectedIndex] == "don't have" {
                Text("I don't have problems with Joints and Ligaments")
                    .chatBubbleText()
            } else {
                Text("I have some problems with \(jointsAndLigamentsArray[medicalInfoViewModel.medicalDetails.jointsAndLigamentsSelectedIndex])")
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
    @ObservedObject var medicalInfoViewModel: MedicalInfoViewModelImpl
    
    @Binding var showJointsAndLigamentsPicker: Bool
    @Binding var showSendButton: Bool
    @Binding var showTypingText: Bool
    @Binding var showMessagePart: Bool
    
    var body: some View {
        ChatBubbleView(direction: .left) {
            Text(medicalQuestionnaireLastMessage)
                .chatBubbleText()
        }
        .onAppear {
            showJointsAndLigamentsPicker.toggle()
            showSendButton.toggle()
            showTypingText.toggle()
            showMessagePart.toggle()
            medicalInfoViewModel.updateMedicalInfo()
        }
    }
}
