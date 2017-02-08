//
//  FaceView.swift
//  FaceView
//
//  Created by Younoussa Ousmane Abdou on 12/29/16.
//  Copyright © 2016 Younoussa Ousmane Abdou. All rights reserved.
//

import UIKit

@IBDesignable // To show the drawing on the storyboard
class FaceView: UIView {
    
    // Make these options visible in the attribute inspector (explicitly type the type)
    @IBInspectable var scale: CGFloat = 0.90 { didSet {setNeedsLayout()} }
    @IBInspectable var mouthCurvature: Double = -1 { didSet {setNeedsLayout()} } // 1 smill or -1 frown (sad)
    @IBInspectable var eyeIsOpen: Bool = false { didSet {setNeedsLayout(); leftEye.eyeOpen = eyeIsOpen; rightEye.eyeOpen = eyeIsOpen} }
    @IBInspectable var eyeBrowTilt: Double = -0.5 { didSet {setNeedsLayout()} }
    @IBInspectable var color = UIColor.blue { didSet {setNeedsLayout(); leftEye.color = color; rightEye.color = color}}
    @IBInspectable var lineWidth: CGFloat = 5.0 { didSet {setNeedsLayout(); leftEye.color = color; rightEye.color = color} }
    
    // Functions
    
    // Gesture Recognizer
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        
        switch recognizer.state {
        case .changed, .ended:
            
            scale *= recognizer.scale
            recognizer.scale = 1.0
            
            // Working
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        default:
            break
        }
    }
    
    private var skullRadius: CGFloat {
        
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
        
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffSet: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = 5.0
        
        return path
    }
    
    private enum Eye {
        
        case Left
        case Right
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        
        eyeCenter.y -= eyeOffset
        
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        
        return eyeCenter
    }
    
    // New Eyes
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    private func createEye() -> EyeView {
        
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        self.addSubview(eye)
        return eye
    }
    
    private func positionEye(eye: EyeView, center: CGPoint) {
        
        let size = skullRadius / Ratios.SkullRadiusToEyeRadius * 2
        eye.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        positionEye(eye: leftEye, center: getEyeCenter(eye: .Left))
        positionEye(eye: rightEye, center: getEyeCenter(eye: .Right))
    }

    
//    private func pathForEye(eye: Eye) -> UIBezierPath {
//        
//        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
//        let eyeCenter = getEyeCenter(eye: eye)
//        
//        if eyeIsOpen {
//            
//            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
//        } else {
//            
//            let path = UIBezierPath()
//            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
//            path.lineWidth = lineWidth
//            
//            return path
//        }
//    }
    
    private func  pathForMouth() -> UIBezierPath {
        
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffSet
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    static let SkullRadiusToBrowOffset: CGFloat = 5
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        
        var tilt = eyeBrowTilt
        
        switch eye {
            
        case .Left: tilt *= -1.0
        case .Right: break
        }
        
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
    
        color.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
//        pathForEye(eye: .Left).stroke()
//        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
        
        }
}
