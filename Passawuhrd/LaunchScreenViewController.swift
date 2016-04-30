//
//  LaunchScreenViewController.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
  // MARK: -- outlets
  
  
  // MARK: -- variables
//  var orb: OrbWrapper!
//  var animator: UIDynamicAnimator!
//  var snap: UISnapBehavior!
  
  // MARK: -- custom functions
  func didLoadStuff() {
//    animator = UIDynamicAnimator(referenceView: view)
//    orb = OrbWrapper(size: 75, center: self.view.center, expansionTime: 1)
//    self.view.addSubview(orb)
  }
  
  func willAppearStuff() {
    
  }
  
  func didAppearStuff() {
    
  }
  
  // MARK: -- required functions
//  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    animator.removeAllBehaviors()
//    if let touch = touches.first {
//      snap = UISnapBehavior(item: orb, snapToPoint: touch.locationInView(view))
//      animator.addBehavior(snap)
//    }
//    
//  }
//  
//  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    animator.removeAllBehaviors()
//    if let touch = touches.first {
//      snap = UISnapBehavior(item: orb, snapToPoint: touch.locationInView(view))
//      animator.addBehavior(snap)
//    }
//    
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    didLoadStuff()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    didAppearStuff()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    willAppearStuff()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
