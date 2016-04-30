//
//  CropViewController.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 2/21/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import SwiftHEXColors
import ANLongTapButton

class CropViewController: UIViewController {
  // MARK: -- outlets
  
  
  // MARK: -- variables
  var model: CropView_model!
  
  
  
  // MARK: -- custom functions
  func didLoadStuff() {
    self.model = CropView_model(master: self)
  }
  
  func willAppearStuff() {
    
  }
  
  func didAppearStuff() {
    
  }
  
  // MARK: -- required functions
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
  
} // end of class

