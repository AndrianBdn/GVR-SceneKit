//
//  HeadTransformExtension.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/21/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import Foundation


extension GVRHeadTransform {
    
    
    // this function return a matrix for SCNNode, that will 
    // keep the object the way viewer seen it initially (when looking to 0,0,-1) 
    // when he is actually looking elsewhere 
    
    // good for VR cursors and sprites
    
    @objc func rotateMatrixForPosition(_ position : SCNVector3) -> SCNMatrix4 {
        let rotationMatrix = GLKMatrix4Transpose(self.headPoseInStartSpace());
        let translationMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
        
        return SCNMatrix4FromGLKMatrix4(GLKMatrix4Multiply(rotationMatrix, translationMatrix));
    }
    

    // the same as above, bot just rotates the position 
    // works good for sphers
    
    func rotateVector(_ position : SCNVector3) -> SCNVector3 {
        let rotationMatrix = GLKMatrix4Transpose(self.headPoseInStartSpace());
        return SCNVector3FromGLKVector3(GLKMatrix4MultiplyVector3(rotationMatrix, SCNVector3ToGLKVector3(position)));
    }

    
}
