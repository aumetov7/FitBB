//
//  CustomHalfSheetView.swift
//  FitBB
//
//  Created by Акбар Уметов on 7/5/22.
//

import SwiftUI

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    let controller = UIViewController()
    var sheetView: SheetView
    var onEnd: () -> ()
    
    @Binding var showSheet: Bool
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let sheetController = CustomHostingController(rootView: sheetView)
        
        if showSheet {
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
//            uiViewController.dismiss(animated: true)
            sheetController.dismiss(animated: true)
        }
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
    
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        view.backgroundColor = .clear
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
//                .large()
            ]
            
            presentationController.prefersGrabberVisible = true
        }
    }
}
