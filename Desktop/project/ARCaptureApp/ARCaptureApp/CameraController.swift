//
//  CameraController.swift
//  ARCaptureApp
//
//  Created by Farid Andika on 14/11/24.
//

import Foundation
import SwiftUI
import AVFoundation
import ARKit
import RealityKit
import UIKit

class CameraController: NSObject, ObservableObject {
    var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?

    // Setup camera
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("No camera available")
            return
        }
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession?.canAddInput(videoDeviceInput) == true {
                captureSession?.addInput(videoDeviceInput)
            } else {
                print("Could not add video input")
                return
            }
        } catch {
            print("Failed to create input: \(error)")
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        if captureSession?.canAddOutput(photoOutput!) == true {
            captureSession?.addOutput(photoOutput!)
        } else {
            print("Could not add photo output")
            return
        }
    }
    
    // Start camera session
    func startCameraSession() {
        captureSession?.startRunning()
    }
    
    // Stop camera session
    func stopCameraSession() {
        captureSession?.stopRunning()
    }
    
    // Capture photo
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: photoSettings, delegate: self)
    }
}


extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Failed to capture photo")
            return
        }
        
        // Simpan atau tampilkan hasil foto
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
