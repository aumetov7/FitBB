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
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            }
        }
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        
//        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

