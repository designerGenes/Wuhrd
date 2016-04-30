//
//  RecallView_model.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/16/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors
import CoreData

public class RecallView_model: NSObject {
  
  // MARK: -- variables
  var master: RecallViewController!
  var imageSequence: [UIImage]!
  var dotSequence = [UIView]()
  var scheduledTimer: NSTimer?

  var switchType: SwitchType!
  var numberOfReplaysAllowed: Int!
  
  
  // MARK: -- custom functions
  func convertImagesToJpg(raw: [NSData]) -> [UIImage]? {
      var cleanedImageList = [UIImage]()
      for image in raw {
        let cleanedImage = UIImage(data: image, scale: 1)
        cleanedImageList.append(cleanedImage!)
      }
      if !cleanedImageList.isEmpty { return cleanedImageList }
      else {return nil }
  }
  
  func buildPhotoEngine() {
    startTimer()
    animateThen(0.5, animations: {
      self.master.imgSequence.fadeIn()
      }, completion: {
        self.createProgressDots()
    })
    
  }
  
  func createProgressDots() {
    let dotCount = self.imageSequence.count
    
    // EXAMPLE: 12 dots
    
    
    let positionalThing = Int(dotCount / 2)  // EXAMPLE: 6
    
    for x in -positionalThing..<dotCount-positionalThing {  // -6..< 6
      let dot = UIView()
      dot.backgroundColor = gray["dark"]
      dot.clipsToBounds = true
      dot.frame.size = CGSizeMake(30, 30)
      dot.layer.cornerRadius = dot.frame.width / 2
      let scrollview = master.scrlDots
      
      scrollview.addSubview(dot)
      dotSequence.append(dot)

      
      dot.snp_makeConstraints(closure: { (make) -> Void in

//        var spacing = 50 * x
//        if x % 2 == 0 { spacing = -spacing }
//        print("\(x % 2)")
        
        make.left.equalTo(master.view.snp_left).offset(25)
        make.size.equalTo(25)
        make.centerY.equalTo(master.view.snp_centerY).offset(40 * x)
      })
      
    }

//    dotSequence.sortInPlace({$0.})
//    print(dotSequence.map({$0.snp_centerY}))
    dotSequence.first!.backgroundColor = blue["light"]!

  }
  
  
  func buildScrollView() {
    
    let view = self.master.view
    let bigScrollView = UIScrollView()
    bigScrollView.frame = CGRectMake(0, 200, view.bounds.width, view.bounds.height-200)
    bigScrollView.backgroundColor = gray["dark"]!
    let fullWidth = view.frame.width * CGFloat(imageSequence.count)
    bigScrollView.pagingEnabled = true
    bigScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    bigScrollView.contentSize = CGSizeMake(fullWidth, view.frame.height-400)
    bigScrollView.userInteractionEnabled = true

    view.addSubview(bigScrollView)


    for (index, image) in imageSequence.enumerate() {
      let imageView = UIImageView(image: image)
//      let rawSize = image.size
      
      imageView.frame.size = view.sizeThatFits(view.bounds.size)
      imageView.frame.origin = CGPointMake(0 + CGFloat(index) * view.frame.width, 0)
      imageView.clipsToBounds = true
      imageView.contentMode = .ScaleAspectFit
//      imageView.frame = master.imgSequence.frame

      bigScrollView.addSubview(imageView)
    }
    master.imgSequence.removeFromSuperview()
    
    
    
  }
  
  func startTimer() {
    self.scheduledTimer = NSTimer.schedule(repeatInterval: 2.0) { timer in
      animateThen(0.5, animations: {
        self.master.imgSequence.fadeOut()
        }, completion: {
          self.master.doNext()
          if self.master.imageIndex >= self.imageSequence.count - 1 { timer.invalidate() }
          animate(0.5) {
            self.master.imgSequence.fadeIn()
          }
      })
    }
  }
  
  
  
  // MARK: -- required functions
  init(master: RecallViewController) {
    PC("CreateViewController_model")
    self.master = master
    super.init()
    
  }
  
} // class dismissed