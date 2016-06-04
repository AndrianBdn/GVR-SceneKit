//
//  GameControllerObjC.m
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/19/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

@import SceneKit;
@import SpriteKit;

#import "VRBoilerplate-Swift.h"
#import "VRControllerObjC.h"


@implementation VRControllerObjC {
    SCNNode *sphereNode;
    SCNNode *hud;
    NSUInteger counter;
}

@synthesize scene;

- (instancetype)init
{
    self = [super init];
    if (!self)
        return self;
    
    scene = [SCNScene scene];
    scene.background.contents = [UIColor lightGrayColor];

    SCNNode *world = [SCNNode node];
    
    
    {
        float theta = M_PI_4;
        
        for(float phi = 0; phi < M_PI*2; phi += M_PI / 10)
        {
            float radius = 16 + phi / M_PI;
            const float x = radius * cos(theta) * sin(phi);
            const float y = radius * sin(theta) * sin(phi);
            const float z = radius * cos(phi);
            
            SCNMaterial *m = [SCNMaterial new];
            m.diffuse.contents = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0];
            
            SCNNode *planetBox = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0]];
            planetBox.geometry.materials = @[m];
            planetBox.position = SCNVector3Make(x, y, z);
            
            [world addChildNode:planetBox];
        }
        
    }
    
    
    [scene.rootNode addChildNode:world];

    

    SCNNode *planeNode = [SCNNode nodeWithGeometry:[SCNPlane planeWithWidth:6 height:6]];
    planeNode.position = SCNVector3Make(0, -4, -14);
    planeNode.eulerAngles = SCNVector3Make(-M_PI_2+0.01, 0, 0);
    planeNode.physicsBody = [SCNPhysicsBody staticBody];
    planeNode.physicsBody.contactTestBitMask = SCNPhysicsCollisionCategoryAll;
    [scene.rootNode addChildNode:planeNode];
    
    sphereNode = [SCNNode nodeWithGeometry:[SCNSphere sphereWithRadius:1.0f]];
    sphereNode.position = SCNVector3Make(0, 0, -14);
    [scene.rootNode addChildNode:sphereNode];
    sphereNode.physicsBody.contactTestBitMask = SCNPhysicsCollisionCategoryAll;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        sphereNode.physicsBody = [SCNPhysicsBody dynamicBody];
    });
    
    
    scene.physicsWorld.contactDelegate = self;

    
    hud = [SCNNode nodeWithGeometry:[SCNPlane planeWithWidth:1 height:1]];
    SCNMaterial *planeMaterial = [SCNMaterial material];
    planeMaterial.diffuse.contents = [[self class] textureWithString:@""];
    hud.geometry.materials = @[planeMaterial];

    [scene.rootNode addChildNode:hud];

    
    return self;
}




- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact {
    [sphereNode.physicsBody applyForce:SCNVector3Make(0, 10, 0) impulse:YES];
    counter++; // no more ++ in Swift soon :(
    
    hud.geometry.materials.firstObject.diffuse.contents =
    [[self class] textureWithString:[NSString stringWithFormat:@"%ld", (unsigned long)counter]];
}








+ (UIImage *)textureWithString:(NSString *)string {
    
    UIImage *texture;
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    [[UIColor whiteColor] set];
    
    [string drawInRect:CGRectMake(0, 0, 200, 200)
        withAttributes:@{
                        NSForegroundColorAttributeName : [UIColor redColor],
                        NSFontAttributeName : [UIFont boldSystemFontOfSize:30]
                        }];
    
    texture = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return texture;
}


- (void)prepareFrameWithHeadTransform:(GVRHeadTransform *)headTransform {
    hud.transform = [headTransform rotateMatrixForPosition:SCNVector3Make(-1, 0, -3)];

}

- (void)eventTriggered {
    
}



@end
