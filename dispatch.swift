//
//  dispatch.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/22/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var GlobalMainQueue: dispatch_queue_t {
  return dispatch_get_main_queue()
}

var GlobalUserInteractiveQueue: dispatch_queue_t {
  return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
}

var GlobalUserInitiatedQueue: dispatch_queue_t {
  return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
}

var GlobalUtilityQueue: dispatch_queue_t {
  return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
}

var GlobalBackgroundQueue: dispatch_queue_t {
  return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
}

public func dispatchToBackground(closure: ()->()) {
  let GRP_holdIt = dispatch_group_create()
  
  dispatch_group_enter(GRP_holdIt)
    print("Background Task Entered")
    dispatch_async(GlobalBackgroundQueue, closure)
  dispatch_group_leave(GRP_holdIt)
  
//  dispatch_group_wait(GRP_holdIt, DISPATCH_TIME_FOREVER)
//    print("Background Task Finished")
  
}
public func dispatchToMain(closure: ()->()) {
  let GRP_holdIt = dispatch_group_create()
  
  dispatch_group_enter(GRP_holdIt)
    print("Main Task Entered")
    dispatch_async(GlobalMainQueue, closure)
  dispatch_group_leave(GRP_holdIt)
  
//  dispatch_group_wait(GRP_holdIt, DISPATCH_TIME_FOREVER)
//    print("Main Task Finished")
  
}


public func inDispatch(group: dispatch_group_t) { dispatch_group_enter(group) }
public func outDispatch(group: dispatch_group_t) { dispatch_group_leave(group) }


public func waitDispatch(group: dispatch_group_t) { dispatch_group_wait(group, DISPATCH_TIME_FOREVER) }
public func notifyDispatch(group: dispatch_group_t, queue: dispatch_queue_t, block: ()->()) { dispatch_group_notify(group, queue, block) }


public func dispatchToUserInteractive(closure: ()->()) { dispatch_async(GlobalUserInteractiveQueue, closure)}
public func dispatchToUserInitiated(closure: ()->()) { dispatch_async(GlobalUserInitiatedQueue, closure)}
public func dispatchToGlobalUtility(closure: ()->()) { dispatch_async(GlobalUserInteractiveQueue, closure)}


public func crashEverything() {
  
}

public func test() {
  dispatchToBackground(crashEverything)
}