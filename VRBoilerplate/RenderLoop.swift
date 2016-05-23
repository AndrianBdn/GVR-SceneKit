//
//  RenderLoop.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/19/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import UIKit

class RenderLoopThreadTarget : NSObject {
    
    let displayLink: CADisplayLink;
    
    init(displayLink: CADisplayLink) {
        self.displayLink = displayLink;
        super.init();
    }
    
 
    func threadMain() {
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        CFRunLoopRun();
    }
    
}


class RenderLoop: NSObject {
    
    let displayLink: CADisplayLink;
    let renderThread : NSThread;
    
    var paused = false {
        didSet {
            displayLink.paused = paused;
        }
    }
    

    init(renderTarget:AnyObject,  selector: Selector) {
        displayLink = CADisplayLink.init(target: renderTarget, selector: selector);
        
        renderThread = NSThread.init(target: RenderLoopThreadTarget.init(displayLink: displayLink),
                                     selector: #selector(RenderLoopThreadTarget.threadMain),
                                     object: nil);

        renderThread.start();
        super.init();
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(applicationWillResignActive),
                                                         name: UIApplicationWillResignActiveNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(applicationDidBecomeActive),
                                                         name: UIApplicationDidBecomeActiveNotification,
                                                         object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func pauseDisplayLink() {
        displayLink.paused = true;
    }
    
    func applicationWillResignActive(notification : NSNotification) {
        self.performSelector(#selector(pauseDisplayLink),
                             onThread: renderThread,
                             withObject: nil,
                             waitUntilDone: true);
    }
    

    func applicationDidBecomeActive(notification : NSNotification) {
        displayLink.paused = false;
    }
    
    func invalidate() {
        self.performSelector(#selector(invalidateRenderThread),
                             onThread: renderThread,
                             withObject: nil,
                             waitUntilDone: false);
    }
    
    func invalidateRenderThread() {
        displayLink.invalidate();
        dispatch_async(dispatch_get_main_queue()) {
            self.renderThread.cancel();
        }
    }

}
