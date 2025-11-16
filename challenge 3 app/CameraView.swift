//
//  CameraView.swift
//  challenge 3 app
//
//  Created by Aksharaa Ramesh on 14/11/25.
//

import Foundation
import SwiftUI
import UIKit
import VisionKit
import Combine
class CropModel: ObservableObject{
    @Published var scannedPages: [UIImage] = []
}

struct CameraView: UIViewControllerRepresentable {
        
        let didFinishWith: ((_ result: Result<[UIImage], Error>) -> Void)
        let didCancel: () -> Void
        
        func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
            let scannerViewController = VNDocumentCameraViewController()
            scannerViewController.delegate = context.coordinator
            return scannerViewController
        }
        
        func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {  }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(with: self)
        }
        
        class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
            let scannerView: CameraView
            
            init(with scannerView: CameraView) {
                self.scannerView = scannerView
            }
            
            func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
                var scannedPages = [UIImage]()
                for i in 0..<scan.pageCount {
                    scannedPages.append(scan.imageOfPage(at: i))
                }
                
                scannerView.didFinishWith(.success(scannedPages))
            }
            
            func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
                scannerView.didCancel()
            }
            
            func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
                scannerView.didFinishWith(.failure(error))
            }
        }
    }

/*
struct CameraView: UIViewControllerRepresentable{
    @Binding var image: UIImage? //bind to parent view's state
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()//create camera picker
        picker.delegate = context.coordinator//set the coordinator as delegate
        picker.sourceType = .camera
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No Update needed
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        let parent: CameraView
        
        init(_ parent: CameraView){
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage{
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
*/
