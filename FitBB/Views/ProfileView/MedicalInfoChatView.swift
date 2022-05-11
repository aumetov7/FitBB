//
//  MedicalInfoChatView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/5/22.
//

import SwiftUI

struct MedicalInfoChatView: View {
    var bloodPressureArray = ["high", "normal", "low"]
    var eyesArray = ["normal", "not normal"]
    var spineArray = ["protrusion", "hernia", "normal"]
    @State private var spinePartArray = ["cervical", "thoracic", "lumbar", "sacrococcygeal"]
    @State private var heartArray = ["don't have", "heart disease", "heart failure", "heart arrhytmia", "heart tachycardia"]
    @State private var jointsAndLigamentsArray = ["don't have", "neck", "shoulders", "elbow/cubit", "wrist", "pelvis", "knee", "ankle"]
    
    @State private var messages = 0
    
    @State private var writing = false
    @State private var showMessagePart = true
    @State private var showTypingText = false
    @State private var startQuestionaire = false
    @State private var showSendButton = false
    
    @State private var showBloodPressurePicker = false
    @State private var bloodPressure = ""
    
    @State private var showEyesPicker = false
    @State private var eyes = ""
    
    @State private var showSpinePicker = false
    @State private var spine = ""
    
    @State private var showSpinePartPicker = false
    @State private var spinePartSelectedIndex = 0
    
    @State private var showHeartPicker = false
    @State private var heartSelectedIndex = 0
    
    @State private var showJointsAndLigamentsPicker = false
    @State private var jointsAndLigamentsSelectedIndex = 0
    
    @ViewBuilder
    func sendBloodPressureMessage() -> some View {
        ChatBubbleView(direction: .right) {
            Text("I have a \(bloodPressure) blood pressure")
                .chatBubbleText()
        }
    }
    
    @ViewBuilder
    func medicalPicker<S: PickerStyle>(title: String, selection: Binding<String>, dataArray: [String], pickerStyle: S) -> some View {
        Picker(title, selection: selection) {
            ForEach(dataArray, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(pickerStyle)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                Text("Medical Questionnaire")
//                    .titleText()
//                    .padding(.top)
                
                VStack {
                    if showTypingText {
                        HStack(spacing: 2) {
                            Text("FitBB Helper typing")
                                .signText()
                            Text("...")
                                .signText()
                                .mask(Rectangle().offset(x: writing ? 0 : -30))
                        }
                        .onAppear {
                            withAnimation(.easeOut(duration: 1).delay(0).repeatForever(autoreverses: true)) {
                                writing.toggle()
                            }
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.04)
                
                Divider()
                
                VStack {
                    ScrollView {
                        
                        ScrollViewReader { value in
                            WelcomeTextView()
                            
                            ForEach(0 ..< messages, id: \.self) { index in
                                buildView(types: messagesArray, index: index)
                            }
                            .onChange(of: messages) { _ in
                                value.scrollTo(messages - 1)
                            }
                        }
                    }
                }
                
                Divider()
                
                VStack {
                    if showMessagePart {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(Color("background"))
                                .frame(height: geometry.size.height * 0.26)
                                .padding([.leading, .trailing])
                            
                            if !startQuestionaire {
                                RaisedButton(buttonText: "Start", action: {
                                    startQuestionaire.toggle()
                                    messages += 1
                                })
                                .padding(.horizontal, 50)
                            } else {
                                HStack(spacing: 40) {
                                    if showBloodPressurePicker {
                                        medicalPicker(title: "Blood Pressure",
                                                      selection: $bloodPressure,
                                                      dataArray: bloodPressureArray,
                                                      pickerStyle: .segmented)
                                        
                                    } else if showEyesPicker {
                                        medicalPicker(title: "Eyes",
                                                      selection: $eyes,
                                                      dataArray: eyesArray,
                                                      pickerStyle: .segmented)
                                    } else if showSpinePicker {
                                        medicalPicker(title: "Spine",
                                                      selection: $spine,
                                                      dataArray: spineArray,
                                                      pickerStyle: .segmented)
                                    } else if showSpinePartPicker {
                                        CustomPicker(data: $spinePartArray,
                                                     selectionIndex: $spinePartSelectedIndex)
                                    } else if showHeartPicker {
                                        CustomPicker(data: $heartArray,
                                                     selectionIndex: $heartSelectedIndex)
                                    }
                                    else if showJointsAndLigamentsPicker {
                                        CustomPicker(data: $jointsAndLigamentsArray,
                                                     selectionIndex: $jointsAndLigamentsSelectedIndex)
                                    }
                                    
                                    if showSendButton {
                                        Button(action: {
                                            messages += 1
                                        }, label: {
                                            Image(systemName: "arrow.up.message.fill")
                                                .resizedToFill(width: 25, height: 25)
                                                .foregroundColor(.blue)
                                        })
                                    }
                                }
                                .padding(.horizontal, 40)
                            }
                        }
                        .padding(.bottom)
                    }
                }
                
            }
        }
    }
    
    var messagesArray: [Any] = [StartTextView.self,
                                BloodPressureTextView.self,
                                BloodPressureAnswerView.self,
                                EyesTextView.self,
                                EyesAnswerView.self,
                                SpineTextView.self,
                                SpineAnswerView.self,
                                SpinePartTextView.self,
                                SpinePartAnswerView.self,
                                HeartTextView.self,
                                HeartTextSecondView.self,
                                HeartAnswerView.self,
                                JointsAndLigamentsTextView.self,
                                JointsAndLigamentsAnswerView.self,
                                FinishTheQuestionaireView.self]
    
    func buildView(types: [Any], index: Int) -> AnyView {
        switch types[index].self {
        case is StartTextView.Type: return AnyView(
            StartTextView(messages: $messages,
                          showTypingText: $showTypingText)
        )
        case is BloodPressureTextView.Type: return AnyView(
            BloodPressureTextView(showBloodPressurePicker: $showBloodPressurePicker,
                                  showSendButton: $showSendButton,
                                  showTypingText: $showTypingText)
        )
        case is BloodPressureAnswerView.Type: return AnyView(
            BloodPressureAnswerView(bloodPressure: $bloodPressure,
                                    messages: $messages,
                                    showTypingText: $showTypingText)
        )
        case is EyesTextView.Type: return AnyView(
            EyesTextView(showBloodPressurePicker: $showBloodPressurePicker,
                         showEyesPicker: $showEyesPicker,
                         showTypingText: $showTypingText)
        )
        case is EyesAnswerView.Type: return AnyView(
            EyesAnswerView(eyes: $eyes,
                           messages: $messages,
                           showTypingText: $showTypingText)
        )
        case is SpineTextView.Type: return AnyView(
            SpineTextView(eyes: $eyes,
                          showSpinePicker: $showSpinePicker,
                          showEyesPicker: $showEyesPicker,
                          showTypingText: $showTypingText)
        )
        case is SpineAnswerView.Type: return AnyView(
            SpineAnswerView(spine: $spine,
                            messages: $messages,
                            showTypingText: $showTypingText)
        )
        case is SpinePartTextView.Type: return AnyView(
            SpinePartTextView(spine: $spine,
                              showSpinePicker: $showSpinePicker,
                              showSpinePartPicker: $showSpinePartPicker,
                              messages: $messages,
                              showTypingText: $showTypingText)
        )
        case is SpinePartAnswerView.Type: return AnyView(
            SpinePartAnswerView(spine: $spine,
                                spinePartSelectedIndex: $spinePartSelectedIndex,
                                spinePartArray: $spinePartArray,
                                messages: $messages,
                                showTypingText: $showTypingText)
        )
        case is HeartTextView.Type: return AnyView(
            HeartTextView(spine: $spine,
                          messages: $messages)
        )
        case is HeartTextSecondView.Type: return AnyView(
            HeartTextSecondView(spine: $spine,
                                showSpinePartPicker: $showSpinePartPicker,
                                showHeartPicker: $showHeartPicker,
                                showTypingText: $showTypingText))
        case is HeartAnswerView.Type: return AnyView(
            HeartAnswerView(heartArray: $heartArray,
                            heartSelectedIndex: $heartSelectedIndex,
                            messages: $messages,
                            showTypingText: $showTypingText)
        )
        case is JointsAndLigamentsTextView.Type: return AnyView(
            JointsAndLigamentsTextView(heartArray: $heartArray,
                                       heartSelectedIndex: $heartSelectedIndex,
                                       showHeartPicker: $showHeartPicker,
                                       showJointsAndLigamentsPicker: $showJointsAndLigamentsPicker,
                                       showTypingText: $showTypingText)
        )
        case is JointsAndLigamentsAnswerView.Type: return AnyView(
            JointsAndLigamentsAnswerView(jointsAndLigamentsArray: $jointsAndLigamentsArray,
                                         jointsAndLigamentsSelectedIndex: $jointsAndLigamentsSelectedIndex,
                                         messages: $messages,
                                         showTypingText: $showTypingText)
        )
        case is FinishTheQuestionaireView.Type: return AnyView(
            FinishTheQuestionaireView(showJointsAndLigamentsPicker: $showJointsAndLigamentsPicker,
                                      showSendButton: $showSendButton,
                                      showTypingText: $showTypingText,
                                      showMessagePart: $showMessagePart)
        )
        default: return AnyView(EmptyView())
        }
    }
}

struct MedicalInfoChatView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalInfoChatView()
    }
}





