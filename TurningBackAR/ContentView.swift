//
//  ContentView.swift
//  TurningBackAR
//
//  Created by Jerry on 2024/7/6.
//

import SwiftUI
import RealityKit
import CoreMotion

struct ContentView : View {
    
    @State var roll: Double = 0.0
    @State var pitch: Double = 0.0
    @State var yaw: Double = 0.0
    
    var body: some View {
        ZStack {
            ARViewContainer(roll: $roll, pitch: $pitch, yaw: $yaw).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Device Attitude")
                    .font(.largeTitle)
                    .padding()
                
                Text("Roll: \(roll, specifier: "%.2f")")
                Text("Pitch: \(pitch, specifier: "%.2f")")
                Text("Yaw: \(yaw, specifier: "%.2f")")
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var motionManager = CMMotionManager()
    
    @State var isShowingModel: Bool = false
    
    @Binding var roll: Double
    @Binding var pitch: Double
    @Binding var yaw: Double
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        self.startDeviceMotionUpdates()
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        var completion: ((Entity?) -> Void)? = { _ in }
        
        // Create new model when isShowingModel is true
        if isShowingModel {
            // Load the "Scene" scene from the "Experience" Reality File
            let boxAnchor = try! Experience.loadScene()
            
            // Add the box anchor to the scene
            arView.scene.anchors.append(boxAnchor)
            
            completion = { _ in
                print("Both actions were completely stopped.")
                self.startDeviceMotionUpdates()
                isShowingModel = false
            }
            
            boxAnchor.actions.done.onAction = completion
        } else {
            arView.scene.anchors.removeAll()
        }
    }
    
    func startDeviceMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [self] (motionData, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let attitude = motionData?.attitude {
                    DispatchQueue.main.async {
                        self.roll = attitude.roll * 180 / .pi
                        self.pitch = attitude.pitch * 180 / .pi
                        self.yaw = attitude.yaw * 180 / .pi
                        
                        if abs(attitude.yaw * 180 / .pi) > 160 {
                            self.isShowingModel = true
                            self.stopDeviceMotionUpdates()
                        }
                    }
                }
            }
        } else {
            print("Device motion is not available")
        }
    }
    
    func stopDeviceMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        print("Device motion updates stopped")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
