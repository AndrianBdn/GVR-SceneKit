
import SceneKit
import GLKit

@objc class Helper : NSObject {
    
    static func viewCursorInsideNode(containerNode: SCNNode, point: SCNVector3, radiusVx: Float, radiusVy: Float, radiusVz: Float) -> SCNNode? {
        
        
        var p1 = point;
        p1.x -= radiusVx; p1.y -= radiusVy; p1.z -= radiusVz;
        
        var p2 = point;
        p2.x += radiusVx; p1.y += radiusVy; p1.z += radiusVz;
        
        let result = containerNode.hitTestWithSegmentFromPoint(p1,
                                                               toPoint: p2,
                                                               options: [SCNHitTestFirstFoundOnlyKey: true]);
        
        
        if let hit = result.first {
            return hit.node;
        }
        
        return nil;
    }
    

    static func matrixForRotating(srcVector: GLKVector3, dstVector: GLKVector3) -> GLKMatrix4 {
        let cross = GLKVector3CrossProduct(srcVector, dstVector);
        let dot = GLKVector3DotProduct(srcVector, dstVector);
        if (dot > 0.99999) {
            return GLKMatrix4Identity;
        }
        
        return GLKMatrix4MakeRotation(acos(dot), cross.x, cross.y, cross.z);
    }
    
    
    static func quaternionToFaceViewerAtZero(position : SCNVector3) -> SCNQuaternion {

        let fromPos2Cam = GLKVector3Normalize(GLKVector3Negate(SCNVector3ToGLKVector3(position)));
        let fromPos2CamXZ = GLKVector3Normalize(GLKVector3Make(fromPos2Cam.x, 0, fromPos2Cam.z));

        let q = GLKQuaternionMakeWithMatrix4(
                    GLKMatrix4Multiply(
                        self.matrixForRotating(fromPos2CamXZ, dstVector: fromPos2Cam),
                        self.matrixForRotating(GLKVector3Make(0, 0, 1), dstVector: fromPos2CamXZ)
            ));
        
        return SCNVector4Make(q.x, q.y, q.z, q.w);
    }

}