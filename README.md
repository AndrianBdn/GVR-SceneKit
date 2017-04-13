


# GVR-SceneKit

This is an example of using Apple SceneKit with [iOS Google Virtual Reality SDK](https://github.com/googlevr/gvr-ios-sdk) for using with [Google Cardboard](https://vr.google.com/cardboard/).

Currently (early <strike>June 2016</strike> April 2017) it is the easiest way to develop VR app on the iPhone. Hope this is going to change after WWDC <strike>2016</strike> 2017.

The project codename is ’VRBoilerplate’ and initially it was prepared for iOS programming competition for [uadevchallenge 2016](http://uawebchallenge.com/). It supports  both Objective-C and Swift.


## Installing 

Install CocoaPods, open VRBoilerplate.xcworkspace, start coding. 


## Usage 

To create and manage scene, you need to implement a class based on VRControllerProtocol.

Than specify that class in Info.plist under VRControllerClass key. 

If you’re using Swift, you need to specify Obj-C runtime class name

```swift 
@objc(VRControllerSwift)
class VRControllerSwift : NSObject, VRControllerProtocol {
// ...
```


## VRControllerProtocol 

Very simple protocol that contains init-constructor and three methods. 

### - scene 

Read-only property that should return SCNScene. Can’t be null, the scene should not be changed during VRController object lifetime. 

### - prepareFrameWithHeadTransform:

The method is called before each frame (one time for both eyes). Argument is head rotation from GVR SDK. 

You can use prepareFrameWithHeadTransform: as a game loop body.

### - eventTriggered

This method is called when magnet on Cardboard is ‘clicked’ (or if there there are tap on Simulator window) 



## Implementation Details 

- Viewer is at the point (0, 0, 0) looking around. The project does not takes into account SCNCamera objects in Scene. After app start the viewer is looking at the direction (0, 0, -1). The direction which viewer is holding Cardboard in the real word is going to be (0, 0, -1) in VR. 

- There are number of problems with integration of GVR and SceneKit. Since GVR is closed source, they are more like ‘known issues’ like now. 

	- reflectivity (.reflectivity > 0) does not work for SCNFloor 
	
	- SpriteKit scenes are not working as a materials 
	
	- There are two warning during build: … direct access in gvr::Singleton gvr::ServerLogger ::GetInstance() to global weak symbol — see [issue](https://github.com/googlevr/gvr-ios-sdk/issues/22) in GVR project. 



