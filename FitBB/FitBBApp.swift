//
//  FitBBApp.swift
//  FitBB
//
//  Created by Акбар Уметов on 9/4/22.
//

import SwiftUI
import Firebase

final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct FitBBApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var sessionService = SessionServiceImpl()
    
    var body: some Scene {
        WindowGroup {
            switch sessionService.state {
            case .loggedIn:
                ContentView()
                    .environmentObject(sessionService)
            case .loggedOut:
                SignView()
            }
        }
    }
}

