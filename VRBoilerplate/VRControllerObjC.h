//
//  GameControllerObjC.h
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/21/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

@class GVRHeadTransform;
@class SCNScene;

@protocol GameControllerProtocol;


@interface VRControllerObjC : NSObject<VRControllerProtocol, SCNPhysicsContactDelegate>

@property (nonatomic, readonly) SCNScene * _Nonnull scene;

- (nonnull instancetype)init;
- (void)prepareFrameWithHeadTransform:(GVRHeadTransform * _Nonnull)headTransform;
- (void)eventTriggered;

@end
