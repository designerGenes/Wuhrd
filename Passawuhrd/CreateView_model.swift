//
//  CreateView_model.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/12/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors
import SnapKit
import CoreData


// put dummy PasswordSequence here
let dummySiteTitles = ["Facebook", "Pornhub", "Gmail", "Da Bank", "iTunes"]
let dummyPasswordSequence = PasswordSequence(siteTitle: "Fake.com", isHiPri: true, switchType: SwitchType.lookalike)

let MAX_COLS = 3



public class CreateViewModel: NSObject {
  
  // MARK: -- variables
  var master: CreateViewController! {
    didSet {
      placeCardsInView()
    }
  }
  var attachCardTasks: [ (UIControlEvents?, Selector?) ] =  [
    (.TouchUpInside, Selector("doPresentImagePicker:") )
  ]
  
  var addCardTasks: [(UIControlEvents?, Selector?) ] = [
    (.TouchUpInside, Selector("doAddCard:")),
//    (.TouchCancel, Selector("goNuts:"))
  ]
  
  var destructiveCardTasks: [(UIControlEvents?, Selector?) ] = [
    (UIControlEvents.TouchUpInside, Selector("changeStateToAdd:")),
//    (UIControlEvents.TouchUpOutside, Selector("touchUpFromDES_STATE")),
//    (UIControlEvents.TouchDown, Selector("beginRemovingPWCards:")),
  ]
  
  var editCardTasks: [ (UIControlEvents?, Selector?) ] = [
    (.TouchUpInside, Selector("doOfferEditOrRemoveOption:"))
  ]
  
  

  //
  func touchUpFromADD_STATE() { print("touchUP inside from ADD_STATE") }
  func touchUpFromDES_STATE() { print("touchUP inside from DES_STATE") }
  //
  
  var inDestructiveState: Bool = false
  
  var row = 0
  var col = 0 {
    didSet { if col >= MAX_COLS { col = 0 ; row++ } }
  }
  var firstRunAroundFlag: Bool = true
  var deathTimer: NSTimer!
  
  var assocPasswordSequence: PasswordSequence! {
    didSet { if self.master.assocPassword == nil { self.master.assocPassword = self.assocPasswordSequence} }
  }
  var focus: PasswordCard!
  var visibleCards = [PasswordCard]() {
    didSet { adjustScrollViewHeight() }
  }
  let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
  
  // MARK: -- custom functions
  func changeStateToAdd(sender: PasswordCard) {
    sender.currentState = CardState.addState
  }
  
  func changeStateToEdit(sender: PasswordCard) {
    sender.currentState = CardState.editState
  }
  
  func beginRemovingPWCards(sender: PasswordCard) {
    if firstRunAroundFlag == true {
      var allActiveCards = assocPasswordSequence.elements.count
      deathTimer = NSTimer.schedule(repeatInterval: 2) { timer in     //      SETTING
        print("There goes another one")
        let theTaken = self.visibleCards.last
        var theTakenIndex: Int = self.visibleCards.indexOf(theTaken!)!
        if self.visibleCards.count > 1 {
          let target = self.visibleCards[theTakenIndex-1]
          target.fadeOut()
          self.visibleCards.removeAtIndex(self.visibleCards.indexOf(target)!)
          
        } else {
          timer.invalidate()
          sender.currentState = CardState.addState
        }
        
      }

  
      
      
      
     firstRunAroundFlag = false
    }
  }

  
  func doAddCard(card: PasswordCard) {
    card.printTag()
    setToAttachComponent(card)
    col++
    createAddCardButton(self.row, col: self.col)

  }
  
  func doRemoveCard() {
    
  }
  
  func switchActions(card: PasswordCard, newList: [(UIControlEvents?, Selector?) ]) {
   card.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
    for action in newList {
      card.addTarget(self, action: action.1!, forControlEvents: action.0!)
    }
  }

  
  func adjustScrollViewHeight() {
    let numRows = self.row + 1  // because of zeroth
    let contentHeight = CGFloat(numRows) * (PWCARD_SIZE.height + PWCARD_BUFFER) + (PWCARD_SIZE.height * 2)
    master.scrlCards.contentSize = CGSize(width: 0, height: contentHeight)
  }
  
  
  func setToAddCard(card: PasswordCard) {
    switchActions(card, newList: addCardTasks)
    card.currentState = CardState.addState
  }
  
  func removeCard(card: PasswordCard) {
    card.fadeOut()
    card.removeEntirely()
    card.removeFromSuperview()
  }
  
  
  
  func setToAttachComponent(card: PasswordCard) {
    switchActions(card, newList: attachCardTasks)
    card.currentState = CardState.attachState
//    card.setImage(UIImage(named: "emptyCard"), forState: .Normal)
    
    card.assocComponent?.assocChar = "∆"
    card.assocComponent?.assocCard = card
  }
  
  func doPresentImagePicker(card: PasswordCard) {
    card.printTag()
    if inDestructiveState == false {
      self.focus = card
      master.presentImagePicker(card.tag)
    } else {
      removeCard(card)
    }
  }
  
  func doOfferEditOrRemoveOption(card: PasswordCard) {
    card.printTag()
    if inDestructiveState == false {
      let myAlert = UIAlertController()
      myAlert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
        self.doPresentImagePicker(card)
      }))
      myAlert.addAction(UIAlertAction(title: "Edit text", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
        self.doAskForCardDescription(card)
      }))
      myAlert.addAction(UIAlertAction(title: "Move", style: .Default, handler: { (UIAlertAction) -> Void in
        //
      }))
      myAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
      self.master.presentViewController(myAlert, animated: true, completion: nil)
    } else {
      removeCard(card)
    }
  }

  
//  func createBlurEffects() {
//    blurView.frame = self.master.view.frame
//    blurView.alpha = 0
//    master.view.addSubview(blurView)
//  }
//  
//  func blur() {
//    if self.blurView.alpha == 0 { self.blurView.fadeIn()
//    } else { self.blurView.fadeOut() }
//  }
  
  
  func placeCardsInView() {
    let view = master.view
    let scrollView = master.scrlCards
    for (index, element) in assocPasswordSequence.elements.enumerate() {
      let newCard = PasswordCard(frame: CGRectMake(0, 0, 100, 100), assocModel: self, bonusClosure: nil)
        element.assocCard = newCard
        newCard.currentState = CardState.attachState
        visibleCards.append(newCard)
  
        newCard.tag = index

        scrollView.addSubview(newCard)
        makeConstraints(newCard, row: row, col: col)
      
        self.col++
    }
    createAddCardButton(row, col: col)
    
  }
  
  
  func createAddCardButton(row: Int, col: Int) {
    var whenLongPressed: (()->())?
    let newAddCard = PasswordCard(frame: CGRectMake(0, 0, 100, 100), assocModel: self, bonusClosure: whenLongPressed)
    let element = PasswordComponent(char: "∆", master: self.assocPasswordSequence)
    element.assocCard = newAddCard
    assocPasswordSequence.elements.append(element)
    
    newAddCard.currentState = CardState.addState
    whenLongPressed = {
      if newAddCard.currentState != CardState.destructiveState {
        newAddCard.currentState = CardState.destructiveState
      }
    }
    
    newAddCard.bonusClosure = whenLongPressed

    visibleCards.append(newAddCard)
    newAddCard.tag = visibleCards.count-1
    newAddCard.alpha = 0
    newAddCard.fadeIn()
    
    
    
    master.scrlCards.addSubview(newAddCard)
    makeConstraints(newAddCard, row: self.row, col: self.col)//visibleCards.count % MAX_COLS)
  }
  
  
  func makeConstraints(card: PasswordCard, row: Int, col: Int) {
    let view = master.view
    let scrollView = master.scrlCards
    card.snp_makeConstraints(closure: { (make) -> Void in
      make.size.equalTo(PWCARD_SIZE)
      switch col {
      case 0:
        make.left.equalTo(scrollView.snp_centerX).offset(-PWCARD_SIZE.width - PWCARD_BUFFER)
      case 1:
        make.centerX.equalTo(scrollView.snp_centerX)
      case 2:
        make.right.equalTo(scrollView.snp_centerX).offset(PWCARD_SIZE.width + PWCARD_BUFFER)
      default:
        break
      }
      let yMultiplier = (PWCARD_SIZE.height * 1.3 * CGFloat(row)) + (PWCARD_BUFFER * 1.25)
      make.top.equalTo(yMultiplier)
    })
  }
  
  
  func doAskForCardDescription(card: PasswordCard) {
    let questionAlert = UIAlertController(title: "Enter Nickname", message: "Tell me what this is:", preferredStyle: .Alert)
    let okButton = UIAlertAction(title: "Ok", style: .Default) { action in
      if let targetTxtField = questionAlert.textFields!.first {
        if let outText = targetTxtField.text?.characters.first {
          card.assocComponent?.assocChar = String(outText)
          card.showChar()
          card.currentState = CardState.editState
        }
      }
      
    }
    okButton.enabled = false
    
    let cancelButton =  UIAlertAction(title: "Cancel", style: .Destructive) { action in
      self.setToAttachComponent(card)
    }
    
    questionAlert.addTextFieldWithConfigurationHandler { nicknameTxtField in
      NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: nicknameTxtField, queue: NSOperationQueue.mainQueue()) { (notification) in
        okButton.enabled = nicknameTxtField.text != ""
      }
    }
    
    
    
    questionAlert.addAction(okButton)
    questionAlert.addAction(cancelButton)
    questionAlert.view.clipsToBounds = true
    
    self.master.presentViewController(questionAlert, animated: true) { completion in
      
    }

  }
  
  //    START OF PASSWORD SEQUENCE SAVE FUNCTION // DO NOT FUCK WITH THIS

  
  func savePasswordSequenceToCore(cleanedPassword: [PasswordComponent], dispatch GRP_SaveToCore_1 : dispatch_group_t) -> Bool? {
    PF("savePasswordSequenceToCore")
    var out: Bool = false
    let GRP_SaveToCore_2 = dispatch_group_create()
    let GRP_SaveToCore_3 = dispatch_group_create()
    
    dispatch_group_enter(GRP_SaveToCore_3)
    dispatchToBackground() {
    
      // ENTER INNER GROUP
      dispatch_group_enter(GRP_SaveToCore_2)  // ENTER function group
      var goForIt: Int = 0
      let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let context: NSManagedObjectContext = appDel.managedObjectContext
      
      // CATCH - less/more characters than original
        if cleanedPassword.count != self.master.startCount {
          let lowHigh = {cleanedPassword.count > self.master.startCount ? "High" : "Low" }()
          dispatchToMain() {    // MAIN QUEUE
            let smallerAlert = BetterAlert(title: "\(lowHigh) Component Count", message: "You originally chose to make this password with \(self.master.startCount) elements.  Right now it has \(cleanedPassword.count) elements.  Is it ok to save this sequence as it is?", hasCancel: true, vc: self.master) {
                goForIt = 1
                dispatch_group_leave(GRP_SaveToCore_2)
            }
          }
        }
        // CATCH - equal number of characters as original
        if cleanedPassword.count == self.master.startCount {
          print("Same number of characters")
          dispatchToMain() {
            goForIt = 1
            // LEAVE INNER GROUP
            dispatch_group_leave(GRP_SaveToCore_2)
          } // end of main
        }
      

  // TRIGGERED INNER GROUP
        dispatch_group_wait(GRP_SaveToCore_2, DISPATCH_TIME_FOREVER)
            if goForIt > 0 {
                print("Creating new core data entity")
                let newPassword = NSEntityDescription.insertNewObjectForEntityForName("Password", inManagedObjectContext: context) as! Password
                newPassword.setValue(self.assocPasswordSequence.siteTitle, forKey: "siteTitle")
                newPassword.setValue(self.assocPasswordSequence.isHighPriority, forKey: "isHighPriority")
                newPassword.setValue(self.assocPasswordSequence.switchType.rawValue, forKey: "switchType")
                for (index, image) in cleanedPassword.map({$0.assocImage!}).enumerate() {
  // MARK: -- image saving / sizing
                    let saveImage = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: context) as! Image
                    saveImage.image = UIImageJPEGRepresentation(image, 1)
                    saveImage.positionInChain = index
                    saveImage.owner = newPassword
                }
            }
                do {
                  try context.save()
                  print("Context saved")
                  out = true
                  dispatchToMain { dispatch_group_leave(GRP_SaveToCore_3) }
                } catch {
                  print("Context NOT saved")
                  out = false
                  dispatchToMain { dispatch_group_leave(GRP_SaveToCore_3) }
                }
//            }
    } //  END background
  dispatch_group_wait(GRP_SaveToCore_3, DISPATCH_TIME_FOREVER)
    print("Leaving func savePasswordSequenceToCore")
    return out
    
  } // end of savePasswordSequenceToCore
  
//    END OF PASSWORD SEQUENCE SAVE FUNCTION // YOU CAN FUCK WITH EVERYTHING AFTER THIS
  

  
  // MARK: -- required functions
  init(master: CreateViewController) {
    PC("CreateViewController_model")
    self.master = master
    self.assocPasswordSequence = master.assocPassword
//    let dummyPasswordSequence = PasswordSequence(size: 3, switchType: SwitchType.lookalike)
//    self.assocPasswordSequence = dummyPasswordSequence  //  dummy data
//    dummyPasswordSequence.siteTitle = dummySiteTitles[Int(random() % dummySiteTitles.count)]
//    dummyPasswordSequence.isHighPriority = true  //{ Int(random() % 2) == 1 ?  true : false }()
//    self.master.startCount = dummyPasswordSequence.elements.count
    
    super.init()
    placeCardsInView()

  }
  
  override init() {
//    self.assocPasswordSequence = PasswordSequence(size: 4, switchType: SwitchType.lookalike)
    super.init()
  }
  

} // end of class
