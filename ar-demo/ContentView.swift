//
//  ContentView.swift
//  ar-demo
//
//  Created by Jhonel Rios Jaimes on 27/03/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let llamaEntity = try! Entity.load(named: "llama")
        llamaEntity.scale = SIMD3(0.5, 0.5, 0.5)
        llamaEntity.transform.translation = [0, -2.5, -8]
        
        // Create a cube model
//        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
//        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//        let model = ModelEntity(mesh: mesh, materials: [material])
//        //        model.transform.translation.y = 0.05
//        model.generateCollisionShapes(recursive: true)
//        model.transform.translation = [0, 0, -0.5]
        
        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(world: .zero)
        anchor.children.append(llamaEntity)
        
        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)
        
        // Add touch gesture
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
//        arView.addGestureRecognizer(tapGesture)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator : NSObject {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView else { return }
            let location = sender.location(in: arView)
            
            // Hit test to find entities under the tapped spot
            let hitTestResults = arView.hitTest(location)
            
            if let firstResult = hitTestResults.first {
                let entity = firstResult.entity
                
                if let modelEntity = entity as? ModelEntity {
                    modelEntity.model?.materials = [SimpleMaterial(color: .random, roughness: 0.15, isMetallic: true)]
                }
            }
        }
    }
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}

#Preview {
    ContentView()
}
