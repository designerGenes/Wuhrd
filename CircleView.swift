//
//  CircleView.swift
//  scalingFuckery
//
//  Created by Jaden Nation on 1/21/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors

class CircleView: UIButton {
  // MARK: -- variables
  var time: CFTimeInterval?
  
  // MARK: -- custom functions
  func fillCircle() {
    
  }
  
  func fadeInText(text: String, font: UIFont?) {
    if let _ = self.time {
      let label = UILabel()
      label.center = self.center ; label.frame = self.bounds
      label.textColor = gray["white"]!
      if let font = font { label.font = font } else {
        label.font = label.font.fontWithSize(24)
      }
      label.textAlignment = .Center
      label.text = text
      label.alpha = 0
      self.addSubview(label)
      animateThen(self.time!, animations: {
        label.alpha = 1
        }, completion: {
          
      })
      

      
    }
  }
  
  func drawCirclePath() {
      fadeIn()
      let ovalPath = UIBezierPath()
      let ovalStartAngle = CGFloat(90.01 * M_PI/180)
      let ovalEndAngle = CGFloat(89.95 * M_PI/180)

      ovalPath.addArcWithCenter(CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds)) , radius: self.bounds.width/2, startAngle: ovalStartAngle, endAngle: ovalEndAngle, clockwise: true)

      let progressLine = CAShapeLayer()
      progressLine.path = ovalPath.CGPath
      progressLine.strokeColor = blue["light"]!.CGColor
      progressLine.fillColor = UIColor.clearColor().CGColor
      progressLine.lineWidth = 10
      progressLine.lineCap = kCALineCapRound
      self.layer.addSublayer(progressLine)
      let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
      animateStrokeEnd.duration = self.time!
      animateStrokeEnd.fromValue = 0.0
      animateStrokeEnd.toValue = 1
      
      progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
    }
  
  
  func dismiss() {
    self.fadeOut()
  }
  
  
  // MARK: -- required functions
  init(size: CGFloat, center: CGPoint, time: CFTimeInterval, text: (String, UIFont?)?) {
    super.init(frame: CGRectMake(center.x - size/2, center.y - size/2, size, size))
    self.center = center
    self.addTarget(self, action: Selector("dismiss"), forControlEvents: .TouchUpInside)
    self.time = time
    self.alpha = 0      //  begin invisible
    if let text = text {
      fadeInText(text.0, font: text.1)
    }
//    drawCirclePath()
    
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  

  
  
}