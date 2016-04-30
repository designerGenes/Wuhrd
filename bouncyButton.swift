//
//  bouncyButton.swift
//  tanningBook
//
//  Created by Jaden Nation on 12/30/15.
//  Copyright © 2015 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit

public let BUTTON_BOUNCE_DELAY = 0.8

@IBDesignable class BouncyButton: UIButton {
  @IBInspectable var reaction: Int = 0
  @IBInspectable var hasShadow: Bool = true
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
  var shadowAdded: Bool = false
  var doesFadeIn: Bool = false
  
  func triggerReaction() {
    switch self.reaction {
    case 0:
      self.transform = CGAffineTransformMakeScale(0.3, 0.3)
      UIView.animateWithDuration(BUTTON_BOUNCE_DELAY,
        delay: 0,
        usingSpringWithDamping: 0.2,
        initialSpringVelocity: 5.0,
        options: UIViewAnimationOptions.AllowUserInteraction,
        animations: {
          self.transform = CGAffineTransformIdentity
        }, completion: nil)
    case 1:
      self.transform = CGAffineTransformMakeScale(0.8, 0.8)
      UIView.animateWithDuration(BUTTON_BOUNCE_DELAY,
        delay: 0,
        usingSpringWithDamping: 0.2,
        initialSpringVelocity: 3.0,
        options: UIViewAnimationOptions.AllowUserInteraction,
        animations: {
          self.transform = CGAffineTransformIdentity
        }, completion: nil)
    default:
      break
    }
  }
  
//  func fadeIn() {
//    animate(0.6) {
//      self.alpha = 1.0
//    }
//  }
  
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    triggerReaction()
    super.touchesBegan(touches, withEvent: event)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.clipsToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    if hasShadow {
      if shadowAdded { return }
      shadowAdded = true
      
      let shadowLayer = UIView(frame: self.frame)
      shadowLayer.backgroundColor = UIColor.clearColor()
      shadowLayer.layer.shadowColor = UIColor.blackColor().CGColor
      shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 15).CGPath
      shadowLayer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
      shadowLayer.layer.shadowOpacity = 0.5
      shadowLayer.layer.shadowRadius = 1
      shadowLayer.layer.masksToBounds = true
      shadowLayer.clipsToBounds = false
      
      self.superview?.addSubview(shadowLayer)
    }
    self.superview?.bringSubviewToFront(self)
  }
  
}