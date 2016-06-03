//
//  RenderLoop.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/19/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import UIKit


class RenderLoop: NSObject {
    
    let displayLink: CADisplayLink;
    
    var paused = false {
        didSet {
            displayLink.paused = paused;
        }
    }
    

    init(renderTarget:AnyObject,  selector: Selector) {
        displayLink = CADisplayLink.init(target: renderTarget, selector: selector);
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)

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
    
    func applicationWillResignActive(notification : NSNotification) {
        displayLink.paused = true;
    }
    

    func applicationDidBecomeActive(notification : NSNotification) {
        displayLink.paused = paused;
    }
    
    func invalidate() {
        displayLink.invalidate();
    }

}
