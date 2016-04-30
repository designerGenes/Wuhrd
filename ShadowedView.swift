//
//  ShadowedView.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 2/26/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors

public class ShadowView: UIView {
// MARK: -- variables
  var shadow: UIView?
  var shadowOffset: (x: CGFloat, y: CGFloat)? {
    didSet {
      if let shadow = shadow {
        let bFrame = self.frame
        shadow.frame = CGRectMake(bFrame.origin.x + shadowOffset!.x, bFrame.origin.y + shadowOffset!.y, bFrame.width, bFrame.height)
        shadow.alpha = 0.75
        
      }
    }
  }


// MARK: -- custom functions
  func createShadow(shadowColor: UIColor, shadowOffset: UIOffset) {
    if let shadow = self.shadow {
      shadow.removeFromSuperview()
      self.shadow = nil
    } else {
      self.shadow = UIView()
      shadow?.frame = self.frame
      shadow?.backgroundColor = shadowColor
      self.addSubview(shadow!)
    }
  }


// MARK: -- required functions

  
  
} // end of class
