//
//  ToggleButton.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 2/21/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import Foundation
import SwiftHEXColors

public class ToggleButton: UIButton {
  // MARK: -- variables
  var toggled: Bool = false

  var customState: Int = 0 {
    didSet {
      if let max = self.maxCustomState {
        if customState > max {
          if let doesLoop = loops {
            if doesLoop == true {
              customState = 0
            } else {
              customState = max
              return
            }
          }
        }
      }
      trigger()
    }
  }
  var maxCustomState: Int?
  var loops: Bool?
  
  

  var colors = [UIColor]() {
    didSet {
      self.backgroundColor = colors.first!
    }
  }
  var labels = [String]() {
    didSet {
      self.setTitle(labels.first!, forState: .Normal)
    }
  }
  
  
  // MARK: -- custom functions
  func setToState(state: Int) {
    for _ in (0..<state) {
      trigger()
    }
  }
  
  func toggle() {
    customState++
  }
  
  func trigger() {
    PF("trigger")
    if !(colors.isEmpty) && colors.count == labels.count {
      let color = colors.removeFirst()
      self.backgroundColor = color
      colors.append(color)
      let label = labels.removeFirst()
      self.setTitle(label, forState: .Normal)
      labels.append(label)
    }

  }

  func load(items: [AnyObject]) {
    if let colors = items as? [UIColor] {
      self.colors = colors
    } else if let labels = items as? [String] {
      self.labels = labels
    }
    
    
  }
  
  
  // MARK: -- required functions
  init(toggled: Bool, frame: CGRect, images: [UIImage]) {
    PC("ToggleButton_customWithImages")
    self.toggled = toggled
    
    super.init(frame: frame)
    self.setImage(images.first!, forState: .Normal)
  }
  
  init(toggled: Bool, frame: CGRect, colors: [UIColor]) {
    PC("ToggleButton_customWithColors")
    self.toggled = toggled
    self.colors = colors
    super.init(frame: frame)
    self.backgroundColor = colors.first!
  }
  

  required public init?(coder aDecoder: NSCoder) {
      PC("ToggleButton")
      super.init(coder: aDecoder)
  }
  
}
