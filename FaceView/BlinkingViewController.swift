//
//  BlinkingViewController.swift
//  FaceView
//
//  Created by Younoussa Ousmane Abdou on 2/7/17.
//  Copyright © 2017 Younoussa Ousmane Abdou. All rights reserved.
//

import UIKit

class BlinkingViewController: FaceViewController {

    private struct BlinkRate {
        
        static let CloseDuration = 0.4
        static let OpenDuration = 2.5
    }
    
    var blinking: Bool = false {
        didSet {
            
            startBlink()
        }
    }
    
    func startBlink() {
        
        if blinking {
            
            faceView.eyeIsOpen = false
            
            Timer.scheduledTimer(timeInterval: BlinkRate.CloseDuration, target: self, selector: #selector(BlinkingViewController.endBlink), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func endBlink() {
        
        faceView.eyeIsOpen = true
        
        Timer.scheduledTimer(timeInterval: BlinkRate.OpenDuration, target: self, selector: #selector(BlinkingViewController.startBlink), userInfo: nil, repeats: false)
    }
    
    // MARK: - View
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        blinking = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        blinking = false
    }

}
