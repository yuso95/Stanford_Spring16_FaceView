//
//  EmotionVC.swift
//  FaceView
//
//  Created by Younoussa Ousmane Abdou on 1/8/17.
//  Copyright © 2017 Younoussa Ousmane Abdou. All rights reserved.
//

import UIKit

class EmotionVC: UIViewController {
    
    private var emotions = [
        "beAngry": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Frown),
        "beSad": FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Neutral),
        "beWorried": FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Neutral),
        "beMishievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: FacialExpression.Mouth.happierMouth(FacialExpression.Mouth.Smile)())
    ]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        var desctinationVC = segue.destination
        
        if let navCon = desctinationVC as? UINavigationController {
            
            desctinationVC = navCon.visibleViewController!
        }
        
        if let faceVC = desctinationVC.contentVC as? FaceViewController {
            
            if let identifier = segue.identifier {
                
                if let theEmotion = emotions[identifier] {
                    
                    faceVC.expression = theEmotion
                    
                    if let button = sender as? UIButton {
                        
                        faceVC.navigationItem.title = button.currentTitle
                    }
                }
            }
        }
    }
}

extension UIViewController {
    
    var contentVC: UIViewController {
        
        if let navCon = self as? UINavigationController {
            
            return navCon.visibleViewController ?? self
        } else {
            
            return self
        }
    }
}
