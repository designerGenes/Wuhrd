//
//  NewPasswordSettingsView.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/15/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import Foundation
import SwiftHEXColors
import SnapKit
import ANLongTapButton


@IBDesignable class NewPasswordSettingsView: UIView {
  // MARK: -- outlets
  @IBOutlet weak var lblSiteNickname: UILabel!
  @IBOutlet weak var txtSiteNickname: UITextField!
  @IBOutlet weak var lblCharacters: UILabel!
  @IBOutlet weak var btnAddChar: UIButton!
  @IBOutlet weak var btnLoseChar: UIButton!
  @IBOutlet weak var lblPriority: UILabel!
  @IBOutlet weak var btnPriorityToggle: UIButton!
  @IBOutlet weak var lblSwapMode: UILabel!
  @IBOutlet weak var btnToggleOrdered: UIButton!
  @IBOutlet weak var btnToggleLookalike: UIButton!
  @IBOutlet weak var btnToggleAlphabet: UIButton!
  @IBOutlet weak var btnToggleSimilar: UIButton!
  @IBOutlet weak var btnInfo: UIButton!
  @IBOutlet weak var btnSubmit: ANLongTapButton!
  @IBOutlet weak var btnCancel: ANLongTapButton!
  @IBOutlet weak var stackSwapMode: UIStackView!


  
  @IBAction func clickedToggleSwapMode(sender: UIButton) { doToggleSwapMode(sender.tag) }
  
  @IBAction func heldOK(sender: ANLongTapButton) {
    sender.didTimePeriodElapseBlock = { ()->Void in
      self.doSubmit()
    }
  }
  
  @IBAction func heldCancel(sender: ANLongTapButton) { doCancel(sender)  }
  @IBAction func clickedInfo(sender: UIButton) { doInfo() }
  @IBAction func heldAddChar(sender: UIButton) { doAddChar() }
  
  
  @IBAction func heldLoseChar(sender: UIButton) { doLoseChar() }
  @IBAction func clickedHiPriority(sender: AnyObject) { toggleHiPriority() }
  @IBAction func touchedView(sender: AnyObject) { txtSiteNickname.resignFirstResponder() }
  @IBAction func DismissKeyboard(sender: AnyObject) { self.resignFirstResponder() }
  

  
  // MARK: -- variables
  var view: UIView!
  var assocViewController: ListViewController!
  var swapModeButtons: [UIButton]!
  
  var newPWChars: Int = DEFAULT_MIN_PW_CHARS {
    didSet {
      lblCharacters.text = "    Characters: \(newPWChars)"
    }
  }
  var newPWSwitchType: Int = 0
  var hiPriorityCounter = 0 { didSet {
    if hiPriorityCounter % 2 == 0 { btnPriorityToggle.setTitle("low", forState: .Normal) } else {
      btnPriorityToggle.setTitle("high", forState: .Normal)
    }
    btnPriorityToggle.backgroundColor = {hiPriorityCounter % 2 == 0 ?  gray["dark"]! : orange["light"]! }()
    if hiPriorityCounter > 1 { hiPriorityCounter == 0 }
    } //    I hate this code.  It's ugly
  }
  
  
  // MARK: -- custom functions
  func doAddChar() {
    self.newPWChars++
    print(self.newPWChars)
  }
  
  func doLoseChar() {
    self.newPWChars--
  }
  
  func doInfo() {
    
  }
  
  
  func doCancel(sender: ANLongTapButton) {
    sender.didTimePeriodElapseBlock = { ()->Void in
       self.unwind()
    }
  }
  
  
  func doSubmit() {
    PF("doSubmit_newPasswordSettings")
    if txtSiteNickname.text != "" {
      let switchTypeDict: [Int: SwitchType] = [
        0: SwitchType.ordered,
        1: SwitchType.lookalike,
        2: SwitchType.alphabet,
        3: SwitchType.similar
      ]
      let newPasswordSequence = PasswordSequence(size: newPWChars, switchType: switchTypeDict[newPWSwitchType]!)
      newPasswordSequence.siteTitle = txtSiteNickname.text
      newPasswordSequence.isHighPriority = {self.hiPriorityCounter % 2 == 0 ? 0 : 1 }()
      unwind()    //      fix for graphics reasons
      assocViewController.performSegueWithIdentifier("segue_sendPasswordToCreateView", sender: newPasswordSequence)
      
      
    }
  }
  
  func doToggleSwapMode(tag: Int) {
    swapModeButtons.filter({$0.tag != tag}).map({$0.backgroundColor = gray["light"]!})
    swapModeButtons.filter({$0.tag == tag}).first!.backgroundColor = blue["light"]!
    self.newPWSwitchType = tag
  }
  
  
  func unwind() {
    if let master = self.assocViewController as? ListViewController {
      master.blur()
      self.removeFromSuperview()
    }
  }
  
  func toggleHiPriority() { hiPriorityCounter++ }
  
  
  // MARK: -- required functions
  
  override init(frame: CGRect) {
    PC("NewPasswordSettingsView")
    super.init(frame: frame)
    xibSetup()
    txtSiteNickname.autocorrectionType = .No
  }
  

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      xibSetup()
      txtSiteNickname.autocorrectionType = .No
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "NewPasswordSettingsView", bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    
    return view
  }
  
  func xibSetup() {
    view = loadViewFromNib()
    view.alpha = 1
    view.frame = bounds
    view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
    self.layer.cornerRadius = self.frame.width/2
    swapModeButtons = [btnToggleOrdered, btnToggleLookalike, btnToggleAlphabet, btnToggleSimilar]
    btnSubmit.timePeriod = BUTTON_TIME_PERIOD  ;   btnCancel.timePeriod = BUTTON_TIME_PERIOD
    btnPriorityToggle.backgroundColor = gray["dark"]!
    lblCharacters.text = "    Characters: \(newPWChars)"
    
    btnPriorityToggle.sizeToFit()
    
    btnCancel.startAngle = BUTTON_START_ANGLE ; btnSubmit.startAngle = -BUTTON_START_ANGLE
    
    doToggleSwapMode(0)
    addSubview(view)
//    btnHiPriority.setTitle("Hi\nPriority", forState: .Normal)

    
  }
  
  

  // MARK: -- constraints
  func buildConstraints() {
//    print("Building constraints")
//    lblSiteNickname.snp_makeConstraints { (make) -> Void in
//      make.top.equalTo(view.snp_top)
//      make.left.equalTo(view.snp_left)
//      make.right.equalTo(view.snp_right)
//      make.height.equalTo(55)
//    }
//    txtSiteNickname.snp_makeConstraints { (make) -> Void in
//      make.top.equalTo(lblSiteNickname.snp_bottom).offset(15)
//      make.centerX.equalTo(view.snp_centerX)
//      make.width.equalTo(200)
//    }
//    lblCharacters.snp_makeConstraints { (make) -> Void in
//      make.top.equalTo(txtSiteNickname.snp_bottom).offset(15)
//      make.left.equalTo(view.snp_left)
//      make.right.equalTo(view.snp_right)
//      make.height.equalTo(55)
//    }
//    sldrCharacters.snp_makeConstraints { (make) -> Void in
//      make.centerX.equalTo(view.snp_centerX)
//      make.top.equalTo(lblCharacters.snp_bottom).offset(20)
////      make.width.equalTo(view.frame.width / 2)
//    }
//    lblSwapMode.snp_makeConstraints { (make) -> Void in
//      make.top.equalTo(sldrCharacters.snp_bottom).offset(20)
//      make.left.equalTo(view.snp_left)
//      make.right.equalTo(view.snp_right)
//      make.height.equalTo(55)
//    }
//    segSwapMode.snp_makeConstraints { (make) -> Void in
//      make.top.equalTo(lblSwapMode.snp_bottom).offset(15)
//      make.width.equalTo(250)
//      make.height.equalTo(30)
//      make.centerX.equalTo(view.snp_centerX)
//    }
//    btnSubmit.snp_makeConstraints { (make) -> Void in
////      make.height.equalTo(255)
//      make.top.equalTo(segSwapMode.snp_bottom).offset(25)
//      make.left.equalTo(view.snp_left)
//      make.right.equalTo(view.snp_centerX)
//      make.bottom.equalTo(view.snp_bottom)
//    }
//    btnCancel.snp_makeConstraints { (make) -> Void in
////      make.width.equalTo(view.frame.width * 0.375)
//      make.top.equalTo(segSwapMode.snp_bottom).offset(25)
////      make.height.equalTo(255)
//      make.left.equalTo(btnSubmit.snp_right)
//      make.right.equalTo(view.snp_centerX).offset(80)
//      make.bottom.equalTo(view.snp_bottom)
//    }
//    btnHiPriority.snp_makeConstraints { (make) -> Void in
////      make.width.equalTo(view.frame.width * 0.25)
//      make.top.equalTo(segSwapMode.snp_bottom).offset(25)
//      make.left.equalTo(btnCancel.snp_right)
//      make.right.equalTo(view.snp_right)
//      make.bottom.equalTo(view.snp_bottom)
//    }
//    
  }
  
  
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
