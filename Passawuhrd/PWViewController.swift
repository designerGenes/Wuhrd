//
//  PWViewController.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 2/16/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit


// might be better served with a protocol or extension

class PWViewController: UIViewController {
  var screenObjects = [UIView]()
  var screenLabels = [UILabel]()
  var screenTxtBoxes = [UITextField]()
  var screenButtons =  [UIButton]()
  var screenImages = [UIImageView]()
  var screenOther = [UIView]()
  
  let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
  
  func blur() {
    if self.blurView.alpha == 0 {
      animate(0.2) {
        self.blurView.alpha = 1
      }
    } else {
      animate(0.2) {
        self.blurView.alpha = 0
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    blurView.frame = view.frame
    blurView.alpha = 0
    view.addSubview(blurView)
  }
  
}

