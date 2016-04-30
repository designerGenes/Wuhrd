//
//  PasswordCard.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/12/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit

public enum CardState: String {
  case attachState = "attachState"
  case addState = "addState"
  case destructiveState = "destructiveState"
  case editState = "editState"
}

@IBDesignable public class PasswordCard: UIButton {
  @IBInspectable var cornerRadius: CGFloat! = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  @IBInspectable var assocImage: UIImage! {
    didSet {
      print("Assigning image to card")
      self.setImage(assocImage!, forState: .Normal)
      if let assocComponent = self.assocComponent {
        assocComponent.assocImage = assocImage
      }
    }
  }
  
  var assocComponent: PasswordComponent?
  var assocModel: CreateViewModel!
  var transientImage: UIImage?
  var charView = UIView()
  let lblChar = UILabel()
  var bonusClosure: (()->())?
  
  var defaultCardTasks: [ (UIControlEvents?, Selector?) ]
  
  var transientTasks : [(UIControlEvents?, Selector?) ]! {
    didSet {
      self.removeTarget(self.assocModel, action: nil, forControlEvents: .AllEvents)
      
      for action in defaultCardTasks {
        self.addTarget(self, action: action.1!, forControlEvents: action.0!)
      }
      
      for action in transientTasks {
        self.addTarget(self.assocModel, action: action.1!, forControlEvents: action.0!)
      }

    }
  }
  
  public var currentState: CardState! {
    didSet {
//      print("Card changed to \(currentState.rawValue)")
      self.transientTasks = self.switchActions(currentState)
      switch currentState.rawValue {
      case CardState.addState.rawValue:
        self.assocModel.inDestructiveState = false
        let addCardImg = UIImage(named: "addCard")!
        let midwayCardImg = UIImage(named: "midwayDestructiveButton")!
        self.setImage(addCardImg, forState: .Normal)
        self.setImage(midwayCardImg, forState: .Highlighted)
        
        
      case CardState.attachState.rawValue:
        let emptyCardImg = UIImage(named: "emptyCard")!
        let emptyCardImg_clicked = UIImage(named: "emptyCard_clicked")!
        self.setImage(emptyCardImg, forState: .Normal)
        self.setImage(emptyCardImg_clicked, forState: .Highlighted)
//        self.setImage(emptyCardImg_clicked, forState: .Selected)
    
      case CardState.editState.rawValue:
        self.setImage(self.assocImage, forState: .Normal)
        self.setImage(self.assocImage, forState: .Highlighted)
        self.setImage(self.assocImage, forState: .Selected)
        
      case CardState.destructiveState.rawValue:
        self.assocModel.inDestructiveState = true
        self.setImage(UIImage(named: "destructiveCard"), forState: .Normal)
        self.setImage(UIImage(named: "destructiveCard"), forState: .Highlighted)
      default:
        break
      }
     
    }
  }
  
  // MARK: -- CUSTOM FUNCTIONS
  
  func removeEntirely() {
    let passwordSeq = self.assocModel.assocPasswordSequence
    print("Removing item with tag \(self.tag)")
    self.assocModel.visibleCards.removeAtIndex(self.tag)
  
    assocModel.assocPasswordSequence.elements.removeAtIndex(self.tag)
    print(assocModel.assocPasswordSequence.elements.count)
    let higherList = passwordSeq.elements.filter({$0.assocCard!.tag > self.tag})
    if !higherList.isEmpty { higherList.map({$0.assocCard!.tag -= 1}) }
    for (index, element) in assocModel.visibleCards.enumerate() {  element.tag = index  }
    
    self.removeFromSuperview()
  }
  
  func showChar() {
    if let assocComponent = self.assocComponent {
      if lblChar.alpha >= 1 {
        animateThen(0.4, animations: {
          self.lblChar.alpha = 0
        }, completion:  {
           self.lblChar.text = assocComponent.assocChar
            animate(0.4) {
              self.lblChar.alpha = 1
            }
        })
      } else {
          self.lblChar.text = assocComponent.assocChar
          animate(0.4) {
            self.charView.alpha = 0.6
            self.lblChar.alpha = 1
      }
      }
    }
  }
  
  func doBonusClosure(sender: UILongPressGestureRecognizer) {
    if let closure = self.bonusClosure {
      closure()
    }
  }

  func addCharToSelf() {
      charView.frame = CGRectMake(0, 0, self.frame.width/3, self.frame.height/3)
      charView.backgroundColor = gray["dark"]!
      charView.alpha = 0
      self.addSubview(charView)
      
      lblChar.font = UIFont(name: "Nexa Bold", size: 20)
      lblChar.textColor = gray["light"]!
      lblChar.textAlignment = .Center
      lblChar.frame = charView.frame
      lblChar.alpha = 0
      charView.addSubview(lblChar)
  
  }
  
  func switchActions(state: CardState) -> [ (UIControlEvents?, Selector?) ] {
    var out = [ (UIControlEvents?, Selector?) ]()
    let model = self.assocModel
    
    switch state.rawValue {
    case CardState.addState.rawValue:  out = model.addCardTasks
    case CardState.attachState.rawValue: out = model.attachCardTasks
    case CardState.editState.rawValue: out = model.editCardTasks
    case CardState.destructiveState.rawValue: out = model.destructiveCardTasks
    default:
      print("ERROR: Hit a default state.")
      out = model.destructiveCardTasks
    }
//    self.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
//    for action in out {
//      self.addTarget(self, action: action.1!, forControlEvents: action.0!)
//    }
    
    return out
  }
  
  func doBoggle(sender: PasswordCard) {
    PF("doBoggle")
    UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
        self.imageView?.transform = CGAffineTransformMakeScale(1.60, 1.60)
      }, completion: { complete in
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
        self.imageView?.transform = CGAffineTransformIdentity
        }, completion: nil)
    })
  }
  
  
  // MARK: -- REQUIRED FUNCTIONS
  
//  public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    let emptyCardImg_clicked = UIImage(named: "emptyCard_clicked")!
//    self.setImage(emptyCardImg_clicked, forState: .Highlighted)
//    super.touchesBegan(touches, withEvent: event)
//  }
//  
//  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    super.touchesMoved(touches, withEvent: event)
//  }
//  
//  public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//    super.touchesCancelled(touches, withEvent: event)
//  }
//  
//  
//  public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {   //  probably remove
//    super.touchesEnded(touches, withEvent: event)
//
//  }
  
  init(frame: CGRect, assocModel: CreateViewModel, bonusClosure: ( ()->() )? ) {
    self.assocModel = assocModel
    self.currentState = .addState
    self.bonusClosure = bonusClosure
    self.defaultCardTasks  = [
      (.TouchDown, Selector("doBoggle:"))
    ]
    
    super.init(frame: frame)
    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("doBonusClosure:"))
//    let touchPressRecognizer = UITapGestureRecognizer(target: self, action: Selector("doBoggle:"))

    

    
    self.addGestureRecognizer(longPressRecognizer)
//    self.addGestureRecognizer(touchPressRecognizer)
    self.userInteractionEnabled = true
    
//    self.assocModel.assocPasswordSequence.elements
    
  }
  

  required public init?(coder aDecoder: NSCoder) {
    self.defaultCardTasks  = [
      (.TouchDown, Selector("doBoggle:"))
    ]
      super.init(coder: aDecoder)
  }
  

    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.cornerRadius = 15 ; self.clipsToBounds = true
        addCharToSelf()
    }


}
