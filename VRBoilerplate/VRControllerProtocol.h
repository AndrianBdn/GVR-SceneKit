//
//  GameControllerProtocol.h
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/20/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

@import SceneKit;

@protocol VRControllerProtocol <NSObject>

- (nonnull instancetype)init;
@property (nonatomic, assign, readonly) SCNScene * _Nonnull scene;
- (void)prepareFrameWithHeadTransform:(GVRHeadTransform * _Nonnull)headTransform;
- (void)eventTriggered;

@end
