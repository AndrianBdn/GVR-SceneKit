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
            displayLink.isPaused = paused;
        }
    }
    

    init(renderTarget:AnyObject,  selector: Selector) {
        displayLink = CADisplayLink.init(target: renderTarget, selector: selector);
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)

        super.init();
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(applicationWillResignActive),
                                                         name: NSNotification.Name.UIApplicationWillResignActive,
                                                         object: nil)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(applicationDidBecomeActive),
                                                         name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                         object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applicationWillResignActive(_ notification : Notification) {
        displayLink.isPaused = true;
    }
    

    func applicationDidBecomeActive(_ notification : Notification) {
        displayLink.isPaused = paused;
    }
    
    func invalidate() {
        displayLink.invalidate();
    }

}
