//
//  ContentView.swift
//  ARCaptureApp
//
//  Created by Farid Andika on 14/11/24.
//

import SwiftUI
import ARKit
import AVFoundation


struct ContentView: View {
    @StateObject private var cameraController = CameraController()
    @State private var isARActive = true // Status apakah AR aktif atau tidak
    @State private var placeObjectAction = false // Menentukan apakah objek AR akan ditempatkan

    var body: some View {
        ZStack {
            if isARActive {
                ARViewContainer(placeObjectAction: $placeObjectAction) // Menggunakan AR
            } else {
                CameraPreviewView(cameraController: cameraController) // Menggunakan AVFoundation
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        placeObjectAction = true // Aktifkan penempatan objek di AR
                    }) {
                        Text("Place Object")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()

                    Button(action: {
                        if isARActive {
                            // Pindah ke AVFoundation untuk foto
                            isARActive = false
                            cameraController.startCameraSession()
                        } else {
                            // Capture foto dan kembali ke AR setelah foto
                            cameraController.capturePhoto()
                            cameraController.stopCameraSession()
                            isARActive = true
                        }
                    }) {
                        Text(isARActive ? "Capture Photo" : "Back to AR")
                            .padding()
                            .background(isARActive ? Color.blue : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            cameraController.setupCamera()
        }
    }
}


