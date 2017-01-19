//
//  ViewController.swift
//  FaceView
//
//  Created by Younoussa Ousmane Abdou on 12/29/16.
//  Copyright © 2016 Younoussa Ousmane Abdou. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    // Var/Let/ CP
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Grin) {
        didSet {
            updateUI()
        }
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5, .Normal: 0.0, .Furrowed: -0.5]
    
    // Outlets
    
    @IBOutlet private weak var faceView: FaceView! {
        didSet {
            
            
            // Working
            let pinchGesture = UIPinchGestureRecognizer(target: faceView, action: #selector(faceView.changeScale(recognizer:)))
            faceView.addGestureRecognizer(pinchGesture)
            
            // NOT WORKING!
            let happierGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierGestureRecognizer)
            
            let sadderGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderGestureRecognizer)
            
            updateUI()
        }
    }
    
    // Actions
    
    @IBAction func toggleEyes(_ recongnizer: UITapGestureRecognizer) {
        
        if recongnizer.state == .ended {
            
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
        
    }
    
    private func updateUI() {
        
        if faceView != nil {
            
            switch expression.eyes {
                
            case .Open: faceView.eyeIsOpen = true
            case . Closed: faceView.eyeIsOpen = false
            case .Squinting: faceView.eyeIsOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    
    // Gesture Functions
    
    func increaseHappiness() {
        
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        
        expression.mouth = expression.mouth.sadderMouth()
    }
}

