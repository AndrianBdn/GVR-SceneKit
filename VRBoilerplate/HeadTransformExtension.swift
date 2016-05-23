//
//  HeadTransformExtension.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/21/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import Foundation


extension GVRHeadTransform {
    
    func rotateVector(position : SCNVector3) -> SCNVector3 {
        
        let rotationMatrix = GLKMatrix4Transpose(self.headPoseInStartSpace());
        return SCNVector3FromGLKVector3(GLKMatrix4MultiplyVector3(rotationMatrix, SCNVector3ToGLKVector3(position)));
        
    }
    
    func rotateMatrixForPosition(position : SCNVector3) -> SCNMatrix4 {
        let rotationMatrix = GLKMatrix4Transpose(self.headPoseInStartSpace());
        let translationMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
        
        return SCNMatrix4FromGLKMatrix4(GLKMatrix4Multiply(rotationMatrix, translationMatrix));
    }
    
}