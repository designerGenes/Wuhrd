////
////  ExpandingOrb.swift
////  scalingFuckery
////
////  Created by Jaden Nation on 1/20/16.
////  Copyright © 2016 Jaden Nation. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SwiftHEXColors
//
//
//public var colors = [orange_one, orange_two, orange_three, orange_four, orange_five]
//
//public class OrbWrapper: UIControl {
//  // MARK: -- variables
//  var currentOrb: ExpandingOrb?
//  var colors = [orange_one, orange_two, orange_three, orange_four, orange_five]
//  
//  
//  
//  // MARK: -- custom functions
//  
//  
//  
//  // MARK: -- required functions
//  init(size: CGFloat, center: CGPoint, expansionTime: NSTimeInterval) {
//    let tempFrame = CGRectMake((center.x - size/4), (center.y - size/4), size, size)
//    super.init(frame: tempFrame)
//    self.center = center
//    
//    
//    self.currentOrb = ExpandingOrb(size: size, center: center, expansionTime: expansionTime, owner: self)
//  }
//  
//  required public init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//  
//  
//  
//  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    
//  }
//  
//}
//
//
//public class ExpandingOrb: UIView {
//  
//  // MARK: -- variables
//  var expansionTime: NSTimeInterval!
//  var originalFrame: (size: CGFloat, center: CGPoint)!
//  var scale: CGFloat = 2
//  var owner: OrbWrapper?
//  
//  // MARK: -- custom functions
//  func expandInSequence(degree: CGFloat) {
//    animateSequence([
//      (time: self.expansionTime, delay: nil, animation: {
//        self.transform = CGAffineTransformMakeScale(self.scale, self.scale)
//        self.alpha = 0.5
//      }),
//      (time: nil, delay: nil, animation: {
//        self.superview!.addSubview(ExpandingOrb(size: self.originalFrame.size, center: self.originalFrame.center, expansionTime: self.expansionTime, owner: self.owner!))
//      }),
//      (time: (self.expansionTime*0.75), delay: nil, animation: {
//        self.transform = CGAffineTransformMakeScale(0.75, 0.75)
//        self.alpha = 0
//      }),
//      (time: nil, delay: nil, animation: {
//        self.removeFromSuperview()
//      })
//      
//      ])
//  }
//  
//  
//  // MARK: -- required functions
//  init(size: CGFloat, center: CGPoint, expansionTime: NSTimeInterval, owner: OrbWrapper) {
//    self.owner = owner
//    super.init(frame: owner.bounds)
//    self.expansionTime = expansionTime
//    self.originalFrame = (size: size, center: center)
//    self.clipsToBounds = true
//    self.layer.cornerRadius = self.frame.width/2
//    self.backgroundColor = self.owner!.colors.removeFirst()
//    self.owner!.colors.append(self.backgroundColor!)
//    self.alpha = 0
//    self.owner!.addSubview(self)
//    
//    
//    animateSequence([
//      (time: (self.expansionTime * 1.25), delay: nil, animation: {
//        self.alpha = 1
//        self.owner!.currentOrb = self
//      }),
//      (time: nil, delay: nil, animation: { self.expandInSequence(self.scale) }),
//      ])
//  }
//  
//  required public init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//  
//}