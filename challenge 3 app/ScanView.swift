//
//  File.swift
//  challenge 3 app
//
//  Created by Aksharaa Ramesh on 7/11/25.
//

import UIKit
import PhotosUI
import Vision
import SwiftUI

struct ScanView: View {
    var body: some View {
        VStack {
            Text("EXPIRING SOON")
                .font(.system(size: 35))
                .font(.callout)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            
            
struct ScanView: View{
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    
    var body: some View{
        VStack{
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ){
                Text("Pick a photo")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .onChange(of: selectedItem){ newItem in
                Task{
                    if let data = try? await newItem?.loadTransferable(type: Data.self){
                        self.imageData = data
                    }
                }
            }
            if let data = imageData,
               let uiImage = UIImage(data: data){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }
        }
    }
}

func extractTable(from image: Data) async throws -> DocumentObservation.Container.Table{
    let request = RecognizeDocumentsRequest()
    let observations = try await request.perform(on: image)
    
    guard let document = observations.first?.document else{
        throw AppError.noDocument
    }
    
    guard let table = document.tables.first else{
        throw AppError.noTable
    }
    
    return table
}

enum AppError: Error{
    case noDocument
    case noTable
}

func loadImage(from item: PhotosPickerItem?) async {
    guard let item = item else{return}
    
    do{
        if let data = try await item.loadTransferable(type: Data.self),
    }
}
//class CameraViewController: UIViewController{
//    private let captureSession = AVCaptureSession()
//    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
//    let photoOutput = AVCapturePhotoOutput()
//    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        setupCamera()
//    }
//}
//
//extension CameraViewController{
//    func setupCamera(){
//        captureSession.sessionPreset = .photo
//        
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: camera)
//        else{
//            print("Unable to access back camera!")
//            return
//        }
//        if captureSession.canAddInput(input){
//            captureSession.addInput(input)
//        }
//        if captureSession.canAddOutput(photoOutput){
//            captureSession.addOutput(photoOutput)
//        }
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewLayer.frame = view.layer.bounds
//        view.layer.addSublayer(videoPreviewLayer)
//        
//        captureSession.startRunning()
//        
//    }
//}
//
//@objc func capturePhoto(){ // have to add as action into shutter button in UI
//    let settings = AVCapturePhotoSettings()
//    settings.flashMode = .auto
//    photoOutput.capturePhoto(with: settings, delegate:self)
//}
//
//extension CameraViewController: AVCapturePhotoCaptureDelegate{
//    func photoOutput(_output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
//        guard let imageData = photo.fileDataRepresentation(), let uiImage = UIImage(data: imageData)
//        else{ return }
//        
//        guard let cgImage = uiImage.cgImage else {return}
//        
//        recognizeDocument(in: cgImage)
//    }
//}
//
//func recognizeDocument(in image: CGImage){
//    
//    
//}
//
//func extractTable(from image: Data) async throws -> DocumentObservation.Container.Table{
//    
//    let request = RecognizeDocumentsRequest()
//    let observations = try await request.perform(on: image)
//    guard let document = observations.first?.document else{
//        throw AppError.noDocument
//    }
//    guard let table = document.tables.first else{
//        throw AppError.noTable
//    } //for error, check if AppError is alr defined in a library or you have to define it yourself, cuz AppError is given in the vid
//    return table
//}
//enum AppError: Error {
//    case noDocument
//    case noTable
//}
//
//struct Receipt{
//    let item: String
//}
//import SwiftUI
//import AVFoundation
//import Vision
//
//struct ScanView: UIViewControllerRepresentable{
//    @Binding var recognizedText: String
//    
//    let captureSession = AVCaptureSession()
//    
//    func makeUIViewController(context: Context) -> UIViewController{
//                    let viewController = UIViewController()
//                    
//                    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
//                          let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
//                          captureSession.canAddInput(videoInput) else { return viewController}
//                    captureSession.addInput(videoInput)
//                    
//                    let videoOutput = AVCaptureVideoDataOutput()
//                    
//                    if captureSession.canAddOutput(videoOutput){
//                        videoOutput.setSampleBufferDelegate(context.Coordinator, queue: DispatchQueue(label: "videoQueue"))
//                        captureSession.addOutput(videoOutput)
//                    }
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = viewController.view.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//        viewController.view.layer.addSublayer(previewLayer)
//        
//        captureSession.startRunning()
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context){}
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//    
//    class Coordinator: NSObject, AVCaptureVideoOutputSampleBufferDelegate {  }
  //  }



