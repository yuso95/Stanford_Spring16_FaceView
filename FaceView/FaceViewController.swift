//
//  ViewController.swift
//  FaceView
//
//  Created by Younoussa Ousmane Abdou on 12/29/16.
//  Copyright © 2016 Younoussa Ousmane Abdou. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    // Mark: - Animation Constants
    
    private struct Animation {
        
        static let ShakeAngle = CGFloat(M_PI/6)
        static let ShakeEndAngle = CGFloat(0)
        static let ShakeDuration = 0.5
    }
    
    // Var/Let/ CP
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Grin) {
        didSet {
            updateUI()
        }
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5, .Normal: 0.0, .Furrowed: -0.5]
    
    // Outlets
    
    @IBOutlet weak var faceView: FaceView! {
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
    
    @IBAction func headShake(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: Animation.ShakeDuration, animations: { 
            
            self.faceView.transform = CGAffineTransform(rotationAngle: Animation.ShakeAngle)
        }) { finished in
            if finished {
                
                UIView.animate(withDuration: Animation.ShakeDuration, animations: { 
                    
                    self.faceView.transform = CGAffineTransform(rotationAngle: -Animation.ShakeAngle * 2)
                }, completion: { finished in
                    if finished {
                        
                        UIView.animate(withDuration: Animation.ShakeDuration, animations: { 
                            
                            // Fix Here because it move way over on the right
                            self.faceView.transform = CGAffineTransform(rotationAngle: Animation.ShakeEndAngle)
                        }, completion: { finished in
                            if finished {
                                
                                
                            }
                        })
                    }
                })
            }
        }
    }
    
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

