//
//  RenderLoop.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/19/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import UIKit


class RenderLoop: NSObject {
    
    var displayLink: CADisplayLink!;
    var renderThread : Thread!
    var paused = false {
        didSet {
            displayLink.isPaused = paused;
        }
    }
    

    init(renderTarget:AnyObject,  selector: Selector) {
        displayLink = CADisplayLink.init(target: renderTarget, selector: selector);
        
        super.init();
        
        renderThread = Thread.init(target: self, selector: #selector(threadMain), object: nil)
        renderThread.start()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive),
                                                     name: NSNotification.Name.UIApplicationWillResignActive,
                                                     object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                                     name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                     object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationWillResignActive(_ notification : Notification) {
        self.perform(#selector(renderThreadSetPaused), on: renderThread, with: nil, waitUntilDone: true)
    }
    
    @objc func applicationDidBecomeActive(_ notification : Notification) {
        displayLink.isPaused = paused;
    }
    
    func invalidate() {
        self.perform(#selector(renderThreadInvalidate), on: renderThread, with: nil, waitUntilDone: false)
    }

    // MARK: render thread
    
    @objc func threadMain() {
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        CFRunLoopRun()
    }
    
    @objc func renderThreadSetPaused() {
        displayLink.isPaused = true
    }
    
    @objc func renderThreadInvalidate() {
        displayLink.invalidate()
        displayLink = nil
        
        CFRunLoopStop(CFRunLoopGetCurrent())
        
        DispatchQueue.main.async {
            self.renderThread.cancel()
            self.renderThread = nil
        }
    
        
    }
    
}
