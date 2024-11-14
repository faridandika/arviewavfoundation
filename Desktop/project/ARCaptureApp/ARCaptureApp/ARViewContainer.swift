//
//  ARViewContainer.swift
//  ARCaptureApp
//
//  Created by Farid Andika on 14/11/24.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var placeObjectAction: Bool  // Binding untuk mengaktifkan penempatan objek
    var arView = ARView(frame: .zero)     // ARView yang digunakan untuk ARKit
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        
        init(parent: ARViewContainer) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            print("AR Session failed with error: \(error.localizedDescription)")
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            // Frame AR diperbarui, bisa digunakan untuk melacak posisi atau status lainnya
            if parent.placeObjectAction {
                // Memanggil metode untuk menempatkan objek di depan kamera
                parent.placeObjectInFront(in: parent.arView)
                parent.placeObjectAction = false  // Reset action setelah objek ditempatkan
            }
        }
    }
    
    func makeUIView(context: Context) -> ARView {
        arView.automaticallyConfigureSession = true
        arView.session.delegate = context.coordinator
        
        // Menyiapkan AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [] // Tidak perlu deteksi permukaan
        configuration.isAutoFocusEnabled = true // Mengaktifkan auto-focus
        
        // Menjalankan session AR dengan konfigurasi yang sudah dibuat
        arView.session.run(configuration)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update ARView jika perlu
        if placeObjectAction {
            placeObjectInFront(in: uiView)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // Fungsi untuk menempatkan objek 3D di depan kamera
    private func placeObjectInFront(in arView: ARView) {
        // Membuat objek 3D berupa kotak
        let boxMesh = MeshResource.generateBox(size: 0.1) // Ukuran kotak 10 cm
        let boxMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        
        // Memastikan frame AR terbaru ada
        guard let cameraTransform = arView.session.currentFrame?.camera.transform else {
            print("Tidak dapat mengambil transformasi kamera")
            return
        }
        
        // Tentukan jarak objek di depan kamera
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.5 // Jarak 0.5 meter di depan kamera
        
        // Transform objek untuk menempatkannya di depan kamera
        let finalTransform = simd_mul(cameraTransform, translation)
        
        // Membuat anchor dan menambahkan objek ke dalamnya
        let anchorEntity = AnchorEntity(world: finalTransform.translation)
        anchorEntity.addChild(boxEntity)
        
        // Menambahkan anchor ke scene AR
        arView.scene.addAnchor(anchorEntity)
        
        // Informasi penempatan objek di AR
        print("Object placed directly in front of the camera")
        
        // Reset aksi untuk penempatan objek
        DispatchQueue.main.async {
            self.placeObjectAction = false
        }
    }
}

// Ekstensi untuk mengubah transformasi ke vektor 3D
extension simd_float4x4 {
    var translation: SIMD3<Float> {
        return SIMD3(x: columns.3.x, y: columns.3.y, z: columns.3.z)
    }
}

