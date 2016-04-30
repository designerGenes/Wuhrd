//
//  extensions.swift
//  tanningBook
//
//  Created by Jaden Nation on 12/30/15.
//  Copyright © 2015 Jaden Nation. All rights reserved.
//

import Foundation
import SwiftHEXColors
import UIKit
import CoreData

protocol RawRepresentable {
  typealias Raw
  static func fromRaw(raw: Raw) -> Self?
  func toRaw() -> Raw
}


extension NSTimer {
  /**
   Creates and schedules a one-time `NSTimer` instance.
   
   :param: delay The delay before execution.
   :param: handler A closure to execute after `delay`.
   
   :returns: The newly-created `NSTimer` instance.
   */
  class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
    let fireDate = delay + CFAbsoluteTimeGetCurrent()
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
    return timer
  }
  
  /**
   Creates and schedules a repeating `NSTimer` instance.
   
   :param: repeatInterval The interval between each execution of `handler`. Note that individual calls may be delayed; subsequent calls to `handler` will be based on the time the `NSTimer` was created.
   :param: handler A closure to execute after `delay`.
   
   :returns: The newly-created `NSTimer` instance.
   */
  class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
    let fireDate = interval + CFAbsoluteTimeGetCurrent()
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
    return timer
  }
}

extension UIView {
  func fadeIn(time: NSTimeInterval = 0.5) {
    if self.alpha < 0.1 {
      animate(time) { self.alpha = 1 }
    }
  }
  func fadeOut(time: NSTimeInterval = 0.5) {
    if self.alpha > 0.9 {
      animate(time) { self.alpha = 0 }
    }
  }
  
}

extension UIButton {
  func printTag() {
//    print("Tag: \(self.tag)")
  }
}

extension UIScrollView {
  func calcContentSize(objectCount: Int, objectHeight: CGFloat, objectWidth: CGFloat) {
    let outHeight = (objectHeight + objectHeight/2) * CGFloat(objectCount)
//    let outWidth
    
  }
  
  
}

extension UIView {
  subscript(index: Int) -> CGPoint {
    var out: CGPoint
    let origin = frame.origin
    switch index {
    case 0:
      out = origin
    case 1:
      out = CGPointMake(origin.x + frame.width, origin.y)
    case 2:
      out = CGPointMake(origin.x, origin.y + frame.height)
    case 3:
      out = CGPointMake(origin.x + frame.width, origin.y + frame.height)
    default:
      out = origin
    }
    
    return out
  }
}

public protocol Numeric {}
extension Float: Numeric {}
extension Int: Numeric {}
extension CGFloat: Numeric {}
extension Double: Numeric {}
extension UInt32: Numeric {}
extension UInt64: Numeric {}
extension UInt16: Numeric {}



// MARK: -- public functions
public func PF(name: String) {
  print("-\t-\t-\t-\t-")
  print("entering function \(name)")
}

public func PC(className: String) {
  print("-\t-\t-\t-\t-")
  print("new instance of \(className)")
}

public func getManagedObjectContext() -> NSManagedObjectContext {
  let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
  let context: NSManagedObjectContext = appDel.managedObjectContext
  return context
}

public typealias ContextBomb = (context: NSManagedObjectContext, model: NSManagedObjectModel, coordinator: NSPersistentStoreCoordinator?)
public func getEverythingRelatedToContext() -> ContextBomb {
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  let managedContext = getManagedObjectContext()
  let out: ContextBomb = (context: managedContext, model: appDelegate.managedObjectModel, coordinator: managedContext.persistentStoreCoordinator)
  return out
}
