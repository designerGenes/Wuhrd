//
//  CreateViewController.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/11/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import SnapKit
import SwiftHEXColors

class CreateViewController: PWViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // MARK: -- outlets
  @IBOutlet weak var scrlCards: UIScrollView!
  @IBOutlet weak var lblSite: UILabel!
  @IBOutlet weak var btnSubmit: UIButton!
  @IBOutlet weak var btnHelp: UIButton!
  @IBOutlet weak var btnCancel: UIButton!
  @IBOutlet weak var btnPriority: ToggleButton!
  
  @IBAction func clickedSubmit(sender: UIButton) { doSubmit() }
  @IBAction func clickedHelp(sender: UIButton) { doShowHelp() }
  @IBAction func clickedCancel(sender: UIButton) { doCancel() }
  @IBAction func clickedPriority(sender: ToggleButton) { sender.toggle() }
  
  @IBAction func doTogglePriority(sender: ToggleButton) {
    //    sender.toggled = !sender.toggled
    if assocPassword?.isHighPriority == 0 { assocPassword?.isHighPriority = 1 }
    else if assocPassword?.isHighPriority == 1 { assocPassword?.isHighPriority = 0 }
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if scrollView.contentOffset.x>0  || scrollView.contentOffset.x < 0 {
      scrollView.contentOffset.x = 0
    }
  }
  

  
  // MARK: -- variables  
  var startCount: Int!
  var assocPassword: PasswordSequence? {
    didSet { startCount = assocPassword!.elements.count }
  }

  
  var model: CreateViewModel!
  let imagePicker = UIImagePickerController()
  
  // MARK: -- custom functions

  func doShowHelp() {
    
  }
  
  func didLoadStuff() {
    self.model = CreateViewModel(master: self)
    self.model.assocPasswordSequence.elements.map({$0.assocChar = "∆"})   //  REMOVE this line when we allow editing
    btnPriority.load([gray["light"]!, orange["light"]!])
    btnPriority.load(["Low", "High"])
    btnPriority.setToState(Int((assocPassword?.isHighPriority)!))
    lblSite.backgroundColor = gray["dark"]!
    lblSite.textColor = gray["white"]!
    lblSite.shadowColor = gray["dark"]
    lblSite.shadowOffset = CGSize(width: 0, height: 10)
    
    
    
    imagePicker.delegate = self
    buildScreenObjectsArray()
    buildConstraints()
    buildScrollViewBasics()
    
    
  }
  
  func presentImagePicker(tag: Int) {
    presentViewController(imagePicker, animated: true) { void in
    
    }
  }
  
  func doCrop(img: UIImage) {
    self.blur()
    let defaultFrame = CGRectMake(0, 0, view.frame.width * 0.75, view.frame.height * 0.65)
    let cropper = CroppingBox(frame: defaultFrame, img: img, master: self)
    cropper.center = view.center
    
    view.addSubview(cropper)

    
    
//    if let focus = model.focus {
//      if focus < model.visibleCards.count {       //  hacky
//        let targetCard = model.visibleCards[focus]
//        targetCard.assocImage = img
//        self.model.doAskForCardDescription(targetCard)
//      }
//    }
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    self.imagePicker.dismissViewControllerAnimated(true, completion: { () -> Void in
      self.doCrop(image)
    })

    
  }
  func cleanArray() -> [PasswordComponent] {
    var adjustableArray: [PasswordComponent] = model.assocPasswordSequence.elements
    let fixedArray: [PasswordComponent] = adjustableArray.filter({$0.assocChar != "∆"})
    
    return fixedArray
  }
  
  
  func doSubmit() {
    print("\n\n\n")
    PF("doSubmit")
    
    let finalSendingPassword = cleanArray()
    let GRP_Submit_1 = dispatch_group_create()
    
    dispatch_async(GlobalBackgroundQueue) {
      dispatch_group_enter(GRP_Submit_1)
      let success = self.model.savePasswordSequenceToCore(finalSendingPassword, dispatch: GRP_Submit_1)
      dispatch_group_leave(GRP_Submit_1)
      
      dispatch_group_wait(GRP_Submit_1, DISPATCH_TIME_FOREVER)
        if success == true {
          dispatchToMain() {
            print("Successful")
              self.performSegueWithIdentifier("segue_successReturnToList", sender: self.model.assocPasswordSequence)
          } // end of main
        } else {
            print("Not successful")
//            let couldNotSaveAlert = BetterAlert(title: "Error while saving", message: "Something went wrong and your password did not save.  Please try again.", hasCancel: false, vc: self, okAction: {self.removeFromParentViewController()})
        }
      }
  }


  func doSettings() {
    
  }
  
  func doCancel() {
    // NOTE: we need a simplified way of creating alerts
//    model.blur()
    let cancelAlert = UIAlertController(title: "Cancel?", message: "Are you sure you want to cancel and lose your progress on this password?", preferredStyle: .Alert)
    let yesButton = UIAlertAction(title: "Yes", style: .Default) { action in
      self.performSegueWithIdentifier("segue_successReturnToList", sender: nil)  // I see u be hackin
    }
    let noButton = UIAlertAction(title: "No", style: .Default) { action in
      
    }
    cancelAlert.addAction(yesButton)
    cancelAlert.addAction(noButton)
    self.presentViewController(cancelAlert, animated: true, completion: nil) // {self.model.blur()})

  }
  
  func willAppearStuff() {
    lblSite.text = self.model.assocPasswordSequence.siteTitle
  }
  
  func didAppearStuff() {
    
  }
  
  func buildScreenObjectsArray() {
    screenLabels = [lblSite]
    screenButtons = [btnSubmit, btnHelp, btnCancel, btnPriority]
    screenOther = [scrlCards]
    screenObjects = [screenLabels, screenButtons, screenOther].flatMap({$0})
    screenObjects.map({$0.translatesAutoresizingMaskIntoConstraints = false})
  }
  
  func buildScrollViewBasics() {
    scrlCards.delegate = self
    scrlCards.contentSize = scrlCards.frame.size
  }
  
  // MARK: -- required functions
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.identifier! {
    case "segue_successReturnToList":
      if let sender = sender {
        if let listView = segue.destinationViewController as? ListViewController {
            print("Segue back to ListViewController")
        }
      }

    default:
      break
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    PC("CreateViewController")
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
  
  
  
  //  Constraint hell.  Run!
  
  func buildConstraints() {
    let mainView = self.view
    lblSite.snp_makeConstraints { (make) -> Void in
      make.height.equalTo(80)
      make.top.equalTo(mainView.snp_top).offset(20)
      make.left.equalTo(mainView.snp_left)
      make.right.equalTo(btnPriority.snp_left)
    }
    btnPriority.snp_makeConstraints { (make) -> Void in
      make.height.equalTo(lblSite.snp_height)
      make.right.equalTo(mainView.snp_right)
      make.top.equalTo(mainView.snp_top).offset(20)
      make.width.greaterThanOrEqualTo(100)
    }
    
    scrlCards.snp_makeConstraints { (make) -> Void in
      make.width.equalTo(mainView.snp_width)
      make.top.equalTo(lblSite.snp_bottom)
      make.bottom.equalTo(btnSubmit.snp_top)
      make.centerX.equalTo(mainView.snp_centerX)
    }
    
//    let distanceFromLabelToRight = view.frame.width - lblSite.frame.width
    
    btnSubmit.snp_makeConstraints { (make) -> Void in
      make.height.equalTo(80)
      make.width.equalTo(mainView.frame.width/3)
      make.left.equalTo(mainView.snp_left)
      make.bottom.equalTo(mainView.snp_bottom)
    }
    btnHelp.snp_makeConstraints { (make) -> Void in
      make.height.equalTo(80)
      make.width.equalTo(mainView.frame.width/3)
      make.left.equalTo(btnSubmit.snp_right)
      make.bottom.equalTo(mainView.snp_bottom)
    }
    btnCancel.snp_makeConstraints { (make) -> Void in
      make.height.equalTo(80)
      make.width.equalTo(mainView.frame.width/3)
      make.right.equalTo(mainView.snp_right)
      make.bottom.equalTo(mainView.snp_bottom)
    }
  }
  

}
