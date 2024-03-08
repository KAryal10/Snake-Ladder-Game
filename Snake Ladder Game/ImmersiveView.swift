//
//  ImmersiveView.swift
//  Snake Ladder Game
//
//  Created by Kritan Aryal on 3/3/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            let floor = ModelEntity( mesh: .generatePlane(width: 50, depth: 50), materials: [OcclusionMaterial()] )
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(
                massProperties: .default,
                mode: .static
            )
            content.add(floor)
            // Add the initial RealityKit content
            if let diceModel = try? await Entity(named: "Dice"),
               let dice = diceModel.children.first{
                dice.scale = [9, 9, 9]
                dice.position.y = 0.5
                dice.position.z = -1
                
                dice.generateCollisionShapes(recursive: false)
                dice.components.set(InputTargetComponent())
                dice.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(
                    massProperties: .default,
                material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.3),
                mode: .dynamic))
                dice.components[PhysicsMotionComponent.self] = .init()
                
                content.add(dice)
            }
        }
        .gesture(dragGesture)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged{ value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
            }
            .onEnded{ value in
                let initialForce = SIMD3<Float>(Float.random(in: -1...1), 0, Float.random(in: -1...1))
                let initialTorque = SIMD3<Float>(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1))
                
                value.entity.components[PhysicsMotionComponent.self] = .init(linearVelocity: initialForce, angularVelocity: initialTorque)
                value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
            }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

