//
//  roundedView.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/20/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors

public class roundedView: UIView {
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.cornerRadius = 15
    self.backgroundColor = gray["light"]!
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  

}