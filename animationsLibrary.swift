//
//  animationsLibrary.swift
//  animationsOne
//
//  Created by Jaden Nation on 11/14/15.
//  Copyright © 2015 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit

public func animate(duration: NSTimeInterval, animations: ()->()) {
  UIView.animateWithDuration(duration, animations: animations)
}

public func animateForever(duration: NSTimeInterval, animations: ()->()) {
  UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.Repeat, animations: animations, completion: nil)
}

public func animateThenReverse(duration: NSTimeInterval, animations: ()->()) {
  UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: animations, completion: nil)
}

public func animateWith(duration: NSTimeInterval, options: UIViewAnimationOptions, animations: ()->()) {
  UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
}

public func animateWait(duration: NSTimeInterval, delay: NSTimeInterval, animations: ()->(), completion: (()->())?) {
  UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.AllowUserInteraction , animations: animations, completion: { _ in
    if let finalTask = completion { finalTask() }
  })
}

public func animateWaitThen(duration: NSTimeInterval, _ delay: NSTimeInterval, animations: ()->(), completion: ()->()) {
  UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.AllowUserInteraction , animations: animations, completion: { _ in
    completion()
  })
}

public func animateWithAndThen(duration: NSTimeInterval, options: UIViewAnimationOptions, animations: ()->(), completion: ()->()) {
  UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: { _ in
    completion()
  })
}

public func animateSpring(duration: NSTimeInterval, damping: CGFloat, speed: CGFloat, options: UIViewAnimationOptions, animations: ()->()) {
  UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: speed, options: options, animations: animations, completion: nil)
}

public func animateThen(duration: NSTimeInterval, animations: ()->(), completion: ()->()) {
  let _ = true
  UIView.animateWithDuration(duration, animations: animations, completion: { _ in
    completion()
  })
}

public func animateWithDelay(time: NSTimeInterval, delay: NSTimeInterval, animations: ()->(), completion: ()->()) {
  let triggerTime = (Int64(NSEC_PER_SEC) * Int64(delay))
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
    UIView.animateWithDuration(time, animations: animations, completion:  { _ in
      completion()
    })
  })
}

public func animateSequence(var animations: [(time: NSTimeInterval?, delay: NSTimeInterval?, animation: ()->() )]) {
  //  USAGE NOTES:
  //    for this to work, each animation's .TIME is how long the animation will take to finish.  This allows you to call functions which contain their own animations, and not fire off the next tuple in the animation sequence until its preceding animation can be expected to be have finished
  //    .DELAY just adds another pause
  
  
  if let animation = animations.first {
    if let time = animation.time {
      if let delay = animation.delay {                  //    Has delay
        animateWithDelay(time, delay: delay, animations: {
          animation.animation()
          }, completion: {
        })
      } else {
        animateThen(time, animations: {               //      Has duration
          animation.animation()
          }, completion: {
        })
      }
    } else {                                          // if nil, just fire everything off and
      animation.animation()                           //  immediately move to next task
    }
    var delayBeforeProgressing: NSTimeInterval = 0
    if let safeTime = animation.time { delayBeforeProgressing += safeTime }
    if let safeDelay = animation.delay { delayBeforeProgressing += safeDelay }
    animateWithDelay(0, delay: delayBeforeProgressing, animations: {
      }, completion: {
        animations.removeFirst()
        animateSequence(animations)
    })
  }
  
//  animateWithDelay(0, delay: <#T##NSTimeInterval#>, animations: <#T##() -> ()#>, completion: <#T##() -> ()#>)
}