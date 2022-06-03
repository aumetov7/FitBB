//
//  HomeView.swift
//  FitBB
//
//  Created by Акбар Уметов on 23/5/22.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @StateObject private var activeEnergyBurnedVM = ActiveEnergyBurnedViewModelImpl(service: ActiveEnergyBurnedServiceImpl())
    @StateObject private var stepVM = StepViewModelImpl(service: StepServiceImpl())
    @StateObject private var exerciseTimeVM = ExerciseTimeViewModelImpl(service: ExerciseTimeServiceImpl())
    
    @State private var showMenu = false
    @State private var showLinkAccount = false
    @State private var showProfileView = false
    
    private var healthStore: HealthStore?
    
    init() {
        healthStore = HealthStore()
    }
    
    var color: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var comma: String {
        return sessionService.userDetails?.firstName != nil ? ", " : ""
    }
    
    var currentProgress: CGFloat {
        if sessionService.userDetails == nil && sessionService.medicalDetails == nil {
            return 0.0
        } else if sessionService.userDetails != nil && sessionService.medicalDetails == nil {
            return 0.5
        } else if sessionService.userDetails == nil && sessionService.medicalDetails != nil {
            return 0.5
        } else {
            return 1.0
        }
    }
    
    var bmrText: String {
        return "\(activeEnergyBurnedVM.activeEnergyBurned.last?.count ?? 0) / \(sessionService.bmrModel?.calculatedRequiredEnergy ?? 0) kcal"
    }
    
    var stepsText: String {
        return "\(stepVM.steps.last?.count ?? 0) / \(sessionService.requiredStepValue ?? 0) steps"
    }
    
    var exercisesTimeText: String {
        return "\(exerciseTimeVM.exercisesTime.last?.count ?? 0) / 60 min"
    }
    
    var stepTextColor: Color {
        if sessionService.getCurrentStepValue() < 0.5 {
            return .indigo
        } else if sessionService.getCurrentStepValue() > 0.5 && sessionService.getCurrentStepValue() < 0.75 {
            return .orange
        } else {
            return .green
        }
    }
    
    var exercisesTimeTextColor: Color {
        if exerciseTimeVM.getCurrentExerciseTimeValue() < 0.5 {
            return .indigo
        } else if exerciseTimeVM.getCurrentExerciseTimeValue() > 0.5 && exerciseTimeVM.getCurrentExerciseTimeValue() < 0.75 {
            return .orange
        } else {
            return .green
        }
    }
    
    var bmrTextColor: Color {
        guard let currentBurnedCalories = sessionService.bmrModel?.currentBurnedCalories else { return .indigo }
        
        if currentBurnedCalories < 0.5 {
            return .indigo
        } else if currentBurnedCalories > 0.5 && currentBurnedCalories < 0.75 {
            return .orange
        } else {
            return .green
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    NavigationLink(destination: LinkAccountView(), isActive: $showLinkAccount) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: ProfileView(), isActive: $showProfileView) {
                        EmptyView()
                    }
                    
                    welcomeText
                        .padding([.top, .bottom])
                    
                    ScrollView {
                        VStack(alignment: .leading ,spacing: 20) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Daily FitBB chart")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Button(action: {}) {
                                    Text("More details")
                                        .font(.system(.callout))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal)
                            
                            smartChart(titleText: "Steps",
                                       valueText: stepsText,
                                       color: stepTextColor,
                                       currentValueText: sessionService.getCurrentStepText(),
                                       currentProgress: sessionService.getCurrentStepValue(),
                                       width: geometry.size.width,
                                       height: geometry.size.height)
                            
                            smartChart(titleText: "Exercises",
                                       valueText: exercisesTimeText,
                                       color: exercisesTimeTextColor,
                                       currentValueText: exerciseTimeVM.getCurrentExerciseTimeText(),
                                       currentProgress: exerciseTimeVM.getCurrentExerciseTimeValue(),
                                       width: geometry.size.width,
                                       height: geometry.size.height)
                            
                            smartChart(titleText: "BMR",
                                       valueText: bmrText,
                                       color: bmrTextColor,
                                       currentValueText: sessionService.getCurrentCaloriesText(),
                                       currentProgress: sessionService.bmrModel?.currentBurnedCalories ?? 0,
                                       width: geometry.size.width,
                                       height: geometry.size.height)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        progressView(width: geometry.size.width * 0.6,
                                     height: geometry.size.height * 0.015)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        menuButton
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        profileButton
                    }
                }
                .halfSheet(showSheet: $showMenu, sheetView: {
                    ProfileMenuView(showProfileMenu: $showMenu,
                                    showLinkAccount: $showLinkAccount)
                    .environmentObject(sessionService)
                }, onEnd: {
                    print("Dismiss")
                })
            }
            .onAppear(perform: {
                if let healthStore = healthStore {
                    healthStore.requestAuthorization { success in
                        if success {
                            print("HealthKit Authorization already done")
                        } else {
                            print("HealthKit Authorization")
                        }
                    }
                }
            })
            .customBackgroundColor(colorScheme: colorScheme)
        }
    }
    
    @ViewBuilder
    func smartChart(titleText: String,
                    valueText: String,
                    color: Color,
                    currentValueText: String,
                    currentProgress: CGFloat,
                    width: CGFloat,
                    height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color("background"))
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(titleText)
                            .raisedButtonTextStyle()
                            .foregroundColor(color)
                            .padding(.bottom, 15)
                        
                        Text(valueText)
                            .signText()
                    }
                    
                    VStack(alignment: .trailing) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 35)
                                .foregroundColor(color)
                                .opacity(0.3)
                            .frame(width: width * 0.35, height: height * 0.05)
                            
                            Text(currentValueText)
                                .foregroundColor(color)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, 15)
                
                ProgressBarView(currentProgress: currentProgress, width: width * 0.8)
            }
            .padding(.horizontal)
        }
        .frame(height: height * 0.2)
    }
    
    var menuButton: some View {
        Button {
            showMenu.toggle()
            print("ShowMenu: \(showMenu)")
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(colorScheme == .dark ? Color("Color2") : Color.white)
                
                Image(systemName: "line.3.horizontal")
                    .resizedToFill(width: 15, height: 15)
                    .font(.headline)
                    .foregroundColor(color)
                    .padding(5)
            }
        }
    }
    
    var profileButton: some View {
        Button {
            showProfileView.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(colorScheme == .dark ? Color("Color2") : Color.white)
                
                AsyncImage(url: URL(string: sessionService.userDetails?.profileImage ?? "")) { image in
                    image
                        .resizedToFill(width: 35, height: 35)
                        .clipShape(Circle())
                        .padding(5)
                } placeholder: {
                    if sessionService.userDetails == nil || sessionService.medicalDetails == nil {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .resizedToFill(width: 35, height: 35)
                            .font(.headline)
                            .foregroundColor(color)
                            .padding(5)
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizedToFill(width: 35, height: 35)
                            .font(.headline)
                            .foregroundColor(color)
                            .padding(5)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func progressView(width: CGFloat, height: CGFloat) -> some View {
        if sessionService.userDetails == nil || sessionService.medicalDetails == nil {
            VStack {
                if sessionService.userDetails == nil && sessionService.medicalDetails == nil {
                    Text("Complete your Profile")
                        .signText()
                        .fixedSize()
                } else if sessionService.userDetails != nil && sessionService.medicalDetails == nil {
                    Text("Complete Medical Details")
                } else if sessionService.userDetails == nil && sessionService.medicalDetails != nil {
                    Text("Complete your Profile Details")
                } else {
                    Text("Great work!")
                }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray)
                        .frame(width: width,
                               height: height)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.green)
                        .frame(width: width * currentProgress,
                               height: height)
                }
            }
        } else {
            EmptyView()
        }
    }
    
    var welcomeText: some View {
        VStack {
            Text(sessionService.getCurrentTime() + comma)
                .roundedTitle()
            
            Text(sessionService.userDetails?.firstName ?? "")
                .roundedTitle()
        }
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SessionServiceImpl())
        
        HomeView()
            .environmentObject(SessionServiceImpl())
            .preferredColorScheme(.dark)
        
        HomeView()
            .environmentObject(SessionServiceImpl())
            .previewDevice("iPhone 8")
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(withURL url: String) {
        imageLoader = ImageLoader(urlString: url)
    }
    
    var body: some View {
        Image(uiImage: imageLoader.image ?? UIImage() )
            .resizedToFill(width: 35, height: 35)
            .clipShape(Circle())
            .padding(5)
    }
}
