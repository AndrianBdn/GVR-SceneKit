//
//  GameControllerSwift.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/21/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import Foundation
import SceneKit;

@objc(VRControllerSwift)
class VRControllerSwift : NSObject, VRControllerProtocol {
    
    let scene = SCNScene();
    
    let world = SCNNode();
    let cursor = SCNNode();
    var boxes = SCNNode();
    
    var focusedNode : SCNNode?
    
    let greyMaterial = VRControllerSwift.material(color: .grayColor())
    let purpleMaterial = VRControllerSwift.material(color: .purpleColor())
    
    // MARK: Game Controller
    
    static func material(color color : UIColor) -> SCNMaterial {
        let m = SCNMaterial();
        m.diffuse.contents = color;
        return m;
    }
    
    required override init() {
        
        scene.background.contents = UIColor.lightGrayColor()
        
        for i in -3 ..< 13 {
            for j in 7 ..< 12 {
                let boxNode: SCNNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
                boxNode.geometry?.materials = [greyMaterial]
                boxNode.position = SCNVector3((Double(i) - 5.0) * 1.2, (Double(j) - 5.0) * 1.2, -10)
                boxNode.physicsBody = SCNPhysicsBody.staticBody()
                boxes.addChildNode(boxNode)
            }
        }
        
        world.addChildNode(boxes)
        
        
        let floor = SCNFloor()
        floor.reflectivity = 0; // does not work in Cardboard SDK
        let floorNode = SCNNode.init(geometry: floor)
        floorNode.position = SCNVector3(0, -20, 0);
        world.addChildNode(floorNode);
        
        
        let backSphere = SCNNode.init(geometry: SCNSphere.init(radius: 120))
        backSphere.position = SCNVector3(0, 0, 180)
        world.addChildNode(backSphere)
        
        
        let light = SCNLight()
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(2,2,2)
        world.addChildNode(lightNode)
        
        cursor.geometry = SCNSphere(radius: 0.2)
        cursor.physicsBody = nil
        
        scene.rootNode.addChildNode(cursor)
        scene.rootNode.addChildNode(world)
    }
    
    func prepareFrameWithHeadTransform(headTransform: GVRHeadTransform) {
        
        cursor.position = headTransform.rotateVector(SCNVector3(0, -3, -9));
        
        // let's create long ray (100 meters) that goes the same way 
        // cursor.position is directed 
        
        let p2 =
            SCNVector3FromGLKVector3(
                GLKVector3MultiplyScalar(
                    GLKVector3Normalize(
                        SCNVector3ToGLKVector3(cursor.position)
                    ),
                    100
                )
            );
        
        let hits = boxes.hitTestWithSegmentFromPoint(SCNVector3Zero, toPoint: p2, options: [SCNHitTestFirstFoundOnlyKey: true]);
        
        if let hit = hits.first {
            focusedNode = hit.node;
        }
        else {
            focusedNode = nil;
        }
        
        boxes.enumerateChildNodesUsingBlock { (node, end) in
            node.geometry?.materials = [self.greyMaterial];
        };
        
        focusedNode?.geometry?.materials = [purpleMaterial];
    }
    
    func eventTriggered() {
        focusedNode?.removeFromParentNode();
    }
    
}


