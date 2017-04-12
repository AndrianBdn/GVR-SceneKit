//
//  SceneKitRenderer.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/19/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class SceneKitVRRenderer: NSObject, GVRCardboardViewDelegate {
    
    let scene: SCNScene;
    var renderer : [SCNRenderer?] = [];
    var renderTime = 0.0 // seconds
    
    init(scene: SCNScene) {
        self.scene = scene;
    }

    
    func createRenderer() -> SCNRenderer {
        let renderer = SCNRenderer.init(context: EAGLContext.current(), options: nil);
        let camNode = SCNNode();
        camNode.camera = SCNCamera();
        renderer.pointOfView = camNode;        
        renderer.scene = scene;
        // comment this out if you would like custom lighting 
        renderer.autoenablesDefaultLighting = true;
        return renderer;
    }
    
    
    func cardboardView(_ cardboardView: GVRCardboardView!, willStartDrawing headTransform: GVRHeadTransform!) {
        renderer.append(createRenderer())
        renderer.append(createRenderer())
        renderer.append(createRenderer())
    }
    
    
    func cardboardView(_ cardboardView: GVRCardboardView!, prepareDrawFrame headTransform: GVRHeadTransform!) {
        glEnable(GLenum(GL_DEPTH_TEST));
        
        // can't get SCNRenderer to do this, has to do myself
        if let color = scene.background.contents as? UIColor {
            var r: CGFloat = 0;
            var g: CGFloat = 0;
            var b: CGFloat = 0;
            color.getRed(&r, green: &g, blue: &b, alpha: nil);
            
            glClearColor(GLfloat(r), GLfloat(g), GLfloat(b), 1);
        }
        else {
            glClearColor(0, 0, 0, 1);
        }
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT));
        glEnable(GLenum(GL_SCISSOR_TEST));
        
        renderTime = CACurrentMediaTime()
    }
    
    func cardboardView(_ cardboardView: GVRCardboardView!, draw eye: GVREye, with headTransform: GVRHeadTransform!) {
        
        let viewport = headTransform.viewport(for: eye);
        glViewport(GLint(viewport.origin.x), GLint(viewport.origin.y), GLint(viewport.size.width), GLint(viewport.size.height));
        glScissor(GLint(viewport.origin.x), GLint(viewport.origin.y), GLint(viewport.size.width), GLint(viewport.size.height));
        
        
        let projection_matrix = headTransform.projectionMatrix(for: eye, near: 0.1, far: 1000.0);
        let model_view_matrix = GLKMatrix4Multiply(headTransform.eye(fromHeadMatrix: eye), headTransform.headPoseInStartSpace())

        guard let eyeRenderer = renderer[eye.rawValue] else {
            fatalError("no eye renderer for eye")
        }
        
        eyeRenderer.pointOfView?.camera?.projectionTransform = SCNMatrix4FromGLKMatrix4(projection_matrix);
        eyeRenderer.pointOfView?.transform = SCNMatrix4FromGLKMatrix4(GLKMatrix4Transpose(model_view_matrix));
        
        if glGetError() == GLenum(GL_NO_ERROR) {
            eyeRenderer.render(atTime: renderTime)
        }
        
    }
    

    
    
}
