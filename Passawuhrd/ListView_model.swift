//
//  ListView_model.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/13/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import SwiftHEXColors
import UIKit
import SnapKit
import CoreData


public class ListViewModel: NSObject {
  // MARK: -- variables
  var master: ListViewController!
  
  var passwordList =  [Password]()
//  var siteTitleList = [String]()
//  var siteIDList = [NSManagedObjectID]()
//  var siteImportanceList = [NSNumber]()
  
  
  // MARK: -- custom functions
  func showRowSettings(id: NSManagedObjectID) {
    
  }
  
  
  
  func deletePassword(id: NSManagedObjectID) {
    dispatchToBackground() {
      let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let context: NSManagedObjectContext = appDel.managedObjectContext
      let object = context.objectWithID(id)
      let deleteGroup = dispatch_group_create()
    
      
      dispatch_group_enter(deleteGroup)
        dispatch_sync(GlobalBackgroundQueue) {
          context.deleteObject(object)
          if object.deleted {
            dispatch_group_leave(deleteGroup)
          }
        }
    
    dispatch_group_wait(deleteGroup, DISPATCH_TIME_FOREVER)
      print("Deleted")
      do {
        try context.save()
        print("Context saved")
        dispatchToMain() { self.master.reloadTable() }
      } catch {
        print("Context NOT saved")
      }
      
    }
  }
  
  func getImagesForSegue(id: NSManagedObjectID) {
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext
    var imgList = [NSData]()
    do {
      let request = NSFetchRequest(entityName: "Password")
      let results = try context.executeFetchRequest(request)
      if !results.isEmpty {
        if let targetItem: Password = context.objectWithID(id) as? Password {
          let startList = (targetItem.images)!
          
          for item in startList {
            if let itemRep = item as? Image { imgList.append(itemRep.image! as NSData) }
          }
          
          let sendPassword = PasswordSequence(siteTitle: targetItem.siteTitle!, isHiPri: Bool(targetItem.isHighPriority!), switchType: SwitchType(rawValue: targetItem.switchType!)!, rawData: imgList)
          
//          let hackySendTuple = HackySendTuple(images: imgList, isHiPri: targetItem.isHighPriority!, siteTitle: targetItem.siteTitle!, switchType: SwitchType(rawValue: targetItem.switchType!)! )
          
          self.master.performSegueWithIdentifier("segue_showRecallView", sender: sendPassword)
        }
      }
      
    } catch {
      print("unable to get stuff")
    }
  }
  
  
  func retrievePasswordList(_ GRP_1: dispatch_group_t) {
    PF("retrievePasswordList")
    dispatch_async(GlobalBackgroundQueue) {
//      dispatch_group_enter(GRP_1) //  BGROUND
      let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let context: NSManagedObjectContext = appDel.managedObjectContext    
      let request = NSFetchRequest(entityName: "Password")
  
      do {
        var results = try context.executeFetchRequest(request) as? [Password]
        if !results!.isEmpty {
          dispatch_sync(GlobalBackgroundQueue) {
            self.passwordList.removeAll(keepCapacity: true)
            results!.sortInPlace() { $0.siteTitle!.lowercaseString < $1.siteTitle!.lowercaseString }
            for item in results!  { self.passwordList.append(item) }
            print("Found \(results!.count) results")
            dispatch_group_leave(GRP_1)
          } // end of background queue
        } else {
          dispatch_sync(GlobalBackgroundQueue) {
            print("Found 0 results")
//            self.master.generateDummyPasswords(5, saveToDB: true)
            dispatch_group_leave(GRP_1)
          }
        }
      } catch {
        print("Unable to retrieve password list")
        dispatch_group_leave(GRP_1)
      }
    }
  }
  
  
  
  
  // MARK: -- required functions
  init(master: ListViewController) {
    PC("listViewController_model")
    self.master = master
    super.init()

  }
  
//  override init() {
//    //
//  }
  

}