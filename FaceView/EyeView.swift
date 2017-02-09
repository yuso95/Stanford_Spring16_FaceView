//
//  EyeView.swift
//  FaceView
//
//  Created by Younoussa Ousmane Abdou on 2/7/17.
//  Copyright © 2017 Younoussa Ousmane Abdou. All rights reserved.
//

import UIKit

class EyeView: UIView {
    
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() }}
    var color: UIColor = UIColor.red { didSet { setNeedsDisplay() }}
    var _eyesOpen: Bool = true { didSet { setNeedsDisplay() }}
    
    var eyeOpen: Bool {
        get {
            
            return _eyesOpen
        }
        set {
            
            EyeView.transition(with: self, duration: 0.2, options: [.transitionFlipFromTop], animations: {
                
                self._eyesOpen = newValue
            }, completion: nil)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        var path: UIBezierPath!
        
        if eyeOpen {
            
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2))
        } else {
            
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
    
}
