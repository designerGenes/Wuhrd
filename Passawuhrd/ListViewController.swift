//
//  ViewController.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/9/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import SwiftHEXColors
import SnapKit
import CoreData
import ANLongTapButton

class ListViewController: PWViewController, UITableViewDataSource, UITableViewDelegate {
  // MARK: -- outlets
//  @IBOutlet weak var imgLogo: UIImageView!
  @IBOutlet weak var btnCreate: ANLongTapButton!
  @IBOutlet weak var tblListPasswords: UITableView!
  @IBOutlet weak var viewTopBar: UIView!
  @IBAction func clickedCreate(sender: AnyObject) {  }
  @IBAction func heldCreate(sender: ANLongTapButton) { doHoldCreate(sender) }

  
//  @IBAction func clickedSettings(sender: AnyObject) { doSettings() }
  
  
  // MARK: -- variables
  var model: ListViewModel!
  var passwordHolder: PasswordSequence?
  
  
  
  
  // MARK: -- custom functions
  func didLoadStuff() {
    btnCreate.setImage(UIImage(named: "btnCreatePassword_held"), forState: .Highlighted)
    btnCreate.timePeriod = BUTTON_TIME_PERIOD
    btnCreate.startAngle = BUTTON_START_ANGLE
    dispatchToBackground( {  self.buildScreenObjectsArray()} )
    buildConstraints()
    model = ListViewModel(master: self)
    tblListPasswords.backgroundColor = gray["light"]!
  }
  
  func willAppearStuff() {
    reloadTable()
  }
  
  func didAppearStuff() {
    assembleLogo(self)
  }
  
  func doHoldCreate(sender: ANLongTapButton) {
    sender.didTimePeriodElapseBlock = { () -> Void in
      self.doCreate()
    }
  }
  
  
  func doCreate() {
    PF("doCreate")
    let preCreateView = NewPasswordSettingsView()
    preCreateView.assocViewController = self
    
    view.addSubview(preCreateView)
    preCreateView.alpha = 0
      preCreateView.snp_makeConstraints(closure: { (make) -> Void in
        make.width.equalTo(self.view.frame.width * 0.85)
        make.height.equalTo(self.view.frame.height * 0.65)
        make.centerX.equalTo(self.view.snp_centerX)
        make.centerY.equalTo(self.view.snp_centerY)
      })
    preCreateView.buildConstraints()
    self.blur()      //  asynchronous?
    animate(0.4) {  preCreateView.alpha = 1    }
    preCreateView.frame = self.view.frame
  }
    
  func doSettings() {
    
  }
  func wipeDatabase(_ GRP_1: dispatch_group_t) -> Bool {
    PF("wipeDatabase")

    var success = false
    let GRP_2 = dispatch_group_create()
    dispatch_group_enter(GRP_2)   //  MAIN
    dispatchToBackground {
      dispatch_group_enter(GRP_1)   //  BGROUND

      let backStory = getEverythingRelatedToContext()
      var passwordList = [Password]()
      do {
        passwordList = try backStory.context.executeFetchRequest(NSFetchRequest(entityName: "Password")) as! [Password]
      } catch { print("No passwords to delete") }
      
      if !passwordList.isEmpty {
        let batchDeletePW = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Password"))
        let batchDeleteIMG = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Image"))
        batchDeletePW.resultType = .ResultTypeStatusOnly ; batchDeleteIMG.resultType = .ResultTypeStatusOnly
        do {
              try backStory.coordinator?.executeRequest(batchDeletePW, withContext: backStory.context)
              try backStory.coordinator?.executeRequest(batchDeleteIMG, withContext: backStory.context)
              print("Successfully deleted all records.")
              success = true
              dispatchToMain { dispatch_group_leave(GRP_2) }
        } catch { print("Unable to delete.  Some records might remain") }
      } else { dispatchToMain { dispatch_group_leave(GRP_2) } }
    } // end of background
    
    dispatch_group_wait(GRP_2, DISPATCH_TIME_FOREVER)
      print("Leaving wipeDatabase with result of \(success)")
      dispatchToBackground { dispatch_group_leave(GRP_1) }
      return success
  }
  
  
  func generateDummyPasswords(count: Int, saveToDB: Bool = false) {
    PF("generateDummyPasswords")
    dispatchToBackground() {
      var dummyPasswordList: [Password] = [Password]()
      let backStory = getEverythingRelatedToContext()
      let GRP_1 = dispatch_group_create()
      
      dispatch_sync(GlobalBackgroundQueue) {
        dispatch_group_enter(GRP_1)             //  BGROUND
        if self.wipeDatabase(GRP_1) == true {   // wipe all existing records
          (0..<count).map { index in            // create new list
            let dummyPassword = NSEntityDescription.insertNewObjectForEntityForName("Password", inManagedObjectContext: backStory.context) as! Password
            dummyPassword.siteTitle = ["Gmail", "Yahoo", "PornHub", "MSN.com", "Bank", "Misc", "Whitehouse.gov", "JohnStamos.org"].flatMap{ $0 }[max(0,rollDice(7))]
            dummyPassword.isHighPriority = flipCoin()
            dummyPassword.switchType = [SwitchType.lookalike, SwitchType.ordered, SwitchType.alphabet, SwitchType.similar].flatMap { $0 } [max(0, rollDice(3))].rawValue

            let dummyImage = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: backStory.context) as! Image
            dummyImage.image = UIImageJPEGRepresentation(UIImage(named: "destructiveCard")!, 1)
            dummyImage.positionInChain = index
            dummyImage.owner = dummyPassword
            dummyPasswordList.append(dummyPassword)
            
            if dummyPasswordList.count == count {
              print("\(dummyPasswordList.count) dummy passwords created")
              dispatchToBackground { dispatch_group_leave(GRP_1) }
            }
          }
        }
      } // end of background
  // save results
        dispatch_group_wait(GRP_1, DISPATCH_TIME_FOREVER)
        dispatchToBackground {
          if saveToDB == true {
            do {
              try backStory.context.save()
              print("Successfully saved dummy passwords")
              dispatchToMain { self.reloadTable() }
            } catch { print("Error saving dummy passwords") }
          }
        }
    } // end of background queue
  }
  
  func buildScreenObjectsArray() {
    screenImages = [ ]
    screenButtons = [btnCreate]
    screenOther = [viewTopBar, tblListPasswords]
    screenObjects = [screenImages, screenButtons, screenOther].flatMap({$0})
//    screenObjects.map({$0.translatesAutoresizingMaskIntoConstraints = false})
  }
  
  
  
  // MARK: -- tableView functions
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    PF("tableView_cell")
    let cell = tblListPasswords.dequeueReusableCellWithIdentifier("passwordCell")! as! PWTableViewCell
    if (indexPath.row < model.passwordList.count) {
      let targetObject = model.passwordList[indexPath.row]
      cell.setProperties(targetObject.siteTitle!, priority: targetObject.isHighPriority!, color: { indexPath.row % 2 == 0 ? gray["list_zed"]!  : gray["list_one"]! }(), id: targetObject.objectID)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.model.passwordList.count
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    PF("tableView_didSelect")
    let targetObject = model.passwordList[indexPath.row] as! Password
    model.getImagesForSegue(targetObject.objectID)
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    PF("tableView_editActions")
    let targetObject = model.passwordList[indexPath.row] as! Password
    
    let settingsSwipeAction = UITableViewRowAction(style: .Default, title: "Settings") { (action: UITableViewRowAction, path: NSIndexPath) -> Void in
      self.model.showRowSettings(targetObject.objectID)
    } // end settings Swipe Action
    
    let deleteSwipeAction = UITableViewRowAction(style: .Default, title: "Delete") { (action: UITableViewRowAction, path: NSIndexPath) -> Void in
      let deleteAlert = BetterAlert(title: "Delete?", message: "Are you sure you want to delete this password?  This action cannot be undone", hasCancel: true, vc: self) {
          print("Delete requested for item at \(indexPath.row)")
          self.model.deletePassword(targetObject.objectID)
      }
    } // end delete Swipe Action
    
    deleteSwipeAction.backgroundColor = orange["failure"]!
    settingsSwipeAction.backgroundColor = blue["dark"]!

    return [deleteSwipeAction, settingsSwipeAction]
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  
  
  func reloadTable() {
    PF("reloadTable")
    let GRP_1 = dispatch_group_create()
    dispatchToBackground() {
      dispatch_group_enter(GRP_1) // BGROUND
        self.model.retrievePasswordList(GRP_1)
      
      dispatch_group_wait(GRP_1, DISPATCH_TIME_FOREVER)
      // functions to take place before reloading
        print("Finished loading passwords")
      dispatchToMain() { self.tblListPasswords.reloadData() }
    }
  }
  
  // MARK: -- required functions
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    PF("prepareForSegue")
    if let id = segue.identifier{
      switch id {
        case "segue_sendPasswordToCreateView":
          if let password = sender as? PasswordSequence {
            if let createView = segue.destinationViewController as? CreateViewController {
              createView.assocPassword = password
            }
        }
        case "segue_showRecallView":
          if let sendPassword = sender as? PasswordSequence {
            if let recallView = segue.destinationViewController as? RecallViewController {
              recallView.focus = sendPassword
//              recallView.rawImageList = hackyTuple.images
//              recallView.isHighPriority = Bool(hackyTuple.isHiPri)
//              recallView.siteTitle = hackyTuple.siteTitle
//              recallView.switchType = hackyTuple.switchType
            }
          }
        default:
          break
      }
    }
  }
  
  override func viewDidLoad() {
    PC("ListViewController")
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
  }

  // MARK: -- CONSTRAINTS
  func buildConstraints() {
    let view = self.view
    viewTopBar.snp_makeConstraints { (make) -> Void in
      make.top.equalTo(view.snp_top)
      make.left.equalTo(view.snp_left)
      make.right.equalTo(view.snp_right)
      make.centerX.equalTo(view.snp_centerX)
      make.height.equalTo(80)
    }
//    imgLogo.snp_makeConstraints { (make) -> Void in
//      make.centerX.equalTo(viewTopBar.snp_centerX)
//      make.centerY.equalTo(viewTopBar.snp_centerY)
//    }
//    tblListPasswords.snp_makeConstraints { (make) -> Void in
//      make.left.equalTo(view.snp_left)
//      make.right.equalTo(view.snp_right)
//      make.top.equalTo(viewTopBar.snp_bottom)
//      make.bottom.equalTo(view.snp_bottom).offset(-90)
//    }
    btnCreate.snp_makeConstraints { (make) -> Void in
      make.centerX.equalTo(view.snp_centerX)
      make.size.equalTo(150)
      make.bottom.equalTo(view.snp_bottom).inset(8)
    }
  }

}

