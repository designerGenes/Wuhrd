//
//  BetterAlert.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/17/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit

public class BetterAlert {
  
  init(title: String, message: String, hasCancel: Bool = false, vc: UIViewController, okAction: ( ()->() )? = nil) {
    PC("BetterAlert")
    let myAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let okButton = UIAlertAction(title: "OK", style: .Default) { action in
      if let okAction = okAction {
        okAction()
      }
    }
    myAlert.addAction(okButton)
    if hasCancel == true {
      let cancelButton = UIAlertAction(title: "Cancel", style: .Default, handler: { action in
        //
      })
      myAlert.addAction(cancelButton)
    }
    
    vc.presentViewController(myAlert, animated: true, completion: nil)
    
  }
}