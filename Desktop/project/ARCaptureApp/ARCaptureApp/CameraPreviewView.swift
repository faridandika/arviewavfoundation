//
//  CameraPreviewView.swift
//  ARCaptureApp
//
//  Created by Farid Andika on 14/11/24.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewControllerRepresentable {
    var cameraController: CameraController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        if let session = cameraController.captureSession {
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = viewController.view.bounds
            viewController.view.layer.addSublayer(previewLayer)
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
