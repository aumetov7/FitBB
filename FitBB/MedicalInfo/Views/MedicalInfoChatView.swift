//
//  MedicalInfoChatView.swift
//  FitBB
//
//  Created by Акбар Уметов on 10/5/22.
//

import SwiftUI

struct MedicalInfoChatView: View {
    @StateObject private var medicalInfoViewModel = MedicalInfoViewModelImpl(
        service: MedicalInfoServiceImpl()
    )
    
    @State private var messages = 0
    @State private var writing = false
    @State private var showMessagePart = true
    @State private var showTypingText = false
    @State private var startQuestionaire = false
    @State private var showSendButton = false
    @State private var showWeightTextField = false
    @State private var showHeightTextField = false
    @State private var showBloodPressurePicker = false
    @State private var showEyesPicker = false
    @State private var showSpinePicker = false
    @State private var showSpinePartPicker = false
    @State private var showHeartPicker = false
    @State private var showJointsAndLigamentsPicker = false
    
    var bloodPressureArray = ["high", "normal", "low"]
    var eyesArray = ["normal", "not normal"]
    var spineArray = ["protrusion", "hernia", "normal"]
    
    var messagesArray: [Any] = [StartTextView.self,
                                WeightTextView.self,
                                WeightAnswerView.self,
                                HeightTextView.self,
                                HeightAnswerView.self,
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
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    if showTypingText {
                        typing
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
                                startButton
                                .padding(.horizontal, 50)
                            } else {
                                messageContent
                                .padding(.horizontal, 40)
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
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
    
    var typing: some View {
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
    
    var startButton: some View {
        RaisedButton(buttonText: "Start", action: {
            startQuestionaire.toggle()
            messages += 1
        })
    }
    
    var weightTextField: some View {
        VStack {
            TextField("", text: $medicalInfoViewModel.medicalDetails.weight)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
            
            Divider()
        }
    }
    
    var heightTextField: some View {
        VStack {
            TextField("", text: $medicalInfoViewModel.medicalDetails.height)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.numberPad)
            
            Divider()
        }
    }
    
    var messageContent: some View {
        HStack(spacing: 40) {
            if showWeightTextField {
                weightTextField
            } else if showHeightTextField {
                heightTextField
            } else if showBloodPressurePicker {
                medicalPicker(title: "Blood Pressure",
                              selection: $medicalInfoViewModel.medicalDetails.bloodPressure,
                              dataArray: bloodPressureArray,
                              pickerStyle: .segmented)
            } else if showEyesPicker {
                medicalPicker(title: "Eyes",
                              selection: $medicalInfoViewModel.medicalDetails.eyes,
                              dataArray: eyesArray,
                              pickerStyle: .segmented)
            } else if showSpinePicker {
                medicalPicker(title: "Spine",
                              selection: $medicalInfoViewModel.medicalDetails.spine,
                              dataArray: spineArray,
                              pickerStyle: .segmented)
            } else if showSpinePartPicker {
                CustomPicker(data: spinePartArray,
                             selectionIndex: $medicalInfoViewModel.medicalDetails.spinePartSelectedIndex)
            } else if showHeartPicker {
                CustomPicker(data: heartArray,
                             selectionIndex: $medicalInfoViewModel.medicalDetails.heartSelectedIndex)
            }
            else if showJointsAndLigamentsPicker {
                CustomPicker(data: jointsAndLigamentsArray,
                             selectionIndex: $medicalInfoViewModel.medicalDetails.jointsAndLigamentsSelectedIndex)
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
    }
    
    func buildView(types: [Any], index: Int) -> AnyView {
        switch types[index].self {
        case is StartTextView.Type: return AnyView(
            StartTextView(messages: $messages,
                          showTypingText: $showTypingText)
        )
        case is WeightTextView.Type: return AnyView(
            WeightTextView(showTypingText: $showTypingText,
                           showSendButton: $showSendButton,
                           showWeightTextField: $showWeightTextField)
        )
        case is WeightAnswerView.Type: return AnyView(
            WeightAnswerView(medicalInfoViewModel: medicalInfoViewModel,
                             showTypingText: $showTypingText,
                             messages: $messages)
        )
        case is HeightTextView.Type: return AnyView(
            HeightTextView(showTypingText: $showTypingText,
                           showWeightTextField: $showWeightTextField,
                           showHeightTextField: $showHeightTextField)
        )
        case is HeightAnswerView.Type: return AnyView(
            HeightAnswerView(medicalInfoViewModel: medicalInfoViewModel,
                             showTypingText: $showTypingText,
                             messages: $messages)
        )
        case is BloodPressureTextView.Type: return AnyView(
            BloodPressureTextView(showHeightTextField: $showHeightTextField,
                                  showBloodPressurePicker: $showBloodPressurePicker,
                                  showTypingText: $showTypingText)
        )
        case is BloodPressureAnswerView.Type: return AnyView(
            BloodPressureAnswerView(medicalInfoViewModel: medicalInfoViewModel,
                                    messages: $messages,
                                    showTypingText: $showTypingText)
        )
        case is EyesTextView.Type: return AnyView(
            EyesTextView(showBloodPressurePicker: $showBloodPressurePicker,
                         showEyesPicker: $showEyesPicker,
                         showTypingText: $showTypingText)
        )
        case is EyesAnswerView.Type: return AnyView(
            EyesAnswerView(medicalInfoViewModel: medicalInfoViewModel,
                           messages: $messages,
                           showTypingText: $showTypingText)
        )
        case is SpineTextView.Type: return AnyView(
            SpineTextView(medicalInfoViewModel: medicalInfoViewModel,
                          showSpinePicker: $showSpinePicker,
                          showEyesPicker: $showEyesPicker,
                          showTypingText: $showTypingText)
        )
        case is SpineAnswerView.Type: return AnyView(
            SpineAnswerView(medicalInfoViewModel: medicalInfoViewModel,
                            messages: $messages,
                            showTypingText: $showTypingText)
        )
        case is SpinePartTextView.Type: return AnyView(
            SpinePartTextView(medicalInfoViewModel: medicalInfoViewModel,
                              showSpinePicker: $showSpinePicker,
                              showSpinePartPicker: $showSpinePartPicker,
                              messages: $messages,
                              showTypingText: $showTypingText)
        )
        case is SpinePartAnswerView.Type: return AnyView(
            SpinePartAnswerView(medicalInfoViewModel: medicalInfoViewModel,
                                messages: $messages,
                                showTypingText: $showTypingText)
        )
        case is HeartTextView.Type: return AnyView(
            HeartTextView(medicalInfoViewModel: medicalInfoViewModel,
                          messages: $messages)
        )
        case is HeartTextSecondView.Type: return AnyView(
            HeartTextSecondView(medicalInfoViewModel: medicalInfoViewModel,
                                showSpinePartPicker: $showSpinePartPicker,
                                showHeartPicker: $showHeartPicker,
                                showTypingText: $showTypingText))
        case is HeartAnswerView.Type: return AnyView(
            HeartAnswerView(medicalInfoViewModel: medicalInfoViewModel,
                            messages: $messages,
                            showTypingText: $showTypingText)
        )
        case is JointsAndLigamentsTextView.Type: return AnyView(
            JointsAndLigamentsTextView(medicalInfoViewModel: medicalInfoViewModel,
                                       showHeartPicker: $showHeartPicker,
                                       showJointsAndLigamentsPicker: $showJointsAndLigamentsPicker,
                                       showTypingText: $showTypingText)
        )
        case is JointsAndLigamentsAnswerView.Type: return AnyView(
            JointsAndLigamentsAnswerView(medicalInfoViewModel: medicalInfoViewModel,
                                         messages: $messages,
                                         showTypingText: $showTypingText)
        )
        case is FinishTheQuestionaireView.Type: return AnyView(
            FinishTheQuestionaireView(medicalInfoViewModel: medicalInfoViewModel,
                                      showJointsAndLigamentsPicker: $showJointsAndLigamentsPicker,
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
