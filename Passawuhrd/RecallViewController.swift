//
//  RecallViewController.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/11/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import SnapKit
import SwiftHEXColors

class RecallViewController: PWViewController {
  // MARK: -- outlets
  @IBOutlet weak var imgSequence: UIImageView!
  @IBOutlet weak var btnCancel: UIButton!
  @IBOutlet weak var btnHelp: UIButton!
  @IBOutlet weak var viewNavigationBar: UIView!
  @IBOutlet weak var scrlDots: UIScrollView!
  
  
  @IBAction func clickedCancel(sender: AnyObject) { doCancel()  }
  @IBAction func clickedHelp(sender: AnyObject) { doShowHelp()  }
  
  
  // MARK: -- variables
  var model: RecallView_model!
//  var rawImageList: [NSData]!
  var focus: PasswordSequence?
 
  
  var imageIndex: Int = 0 {
    didSet {
      if imageIndex < model.imageSequence.count && imageIndex >= 0 {
        imgSequence.image = model.imageSequence[imageIndex]
        if !self.model.dotSequence.isEmpty {
              self.model.dotSequence.map({$0.fadeOut()})
              self.model.dotSequence.map({$0.backgroundColor = gray["dark"]!})
          self.model.dotSequence[self.imageIndex].backgroundColor = blue["light"]!
              self.model.dotSequence.map({$0.fadeIn()})


        }
      }
    }
  }
  
  
  
  // MARK: -- custom functions
  func doPrevious() {        //    remove
    if imageIndex > 0 {
      imageIndex--
    }
  }
  func doNext() {            //    remove
    if imageIndex < (model.imageSequence.count-1) {
      imageIndex++
    }
  }
  func doCancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  func doRestart() {
    
  }
  
  func doShowHelp() {
    
  }
  
  func didLoadStuff() {
    self.model = RecallView_model(master: self)
//    view.backgroundColor = gray_dark

    buildScreenObjectsArray()
    buildConstraints()
    
//    print(focus.elements.count)
    if let focus = self.focus {
      self.model.imageSequence = model.convertImagesToJpg(focus.rawData!)!
    }
    imgSequence.alpha = 0
  }
  
  func willAppearStuff() {
    imageIndex = 0
    self.imgSequence.alpha = 0
  }
  
  func didAppearStuff() {
//    var textSnip = {self.model.isHighPriority == true ? "Hi" : "Lo" }()
    let  introView = CircleView(size: 200, center: self.view.center, time: 3, text: ("\(focus!.siteTitle)", UIFont(name: "Nexa Bold", size: 20)))
    self.view.addSubview(introView)
    animateSequence([
      (time: introView.time!, delay: 1, animation: {
        introView.drawCirclePath()
      }),
      (time: 3, delay: nil, animation: {
        introView.fadeOut()
      }),
      (time: nil, delay: nil, animation: {
        self.model.buildPhotoEngine()
//        if self.focus.isHighPriority == true { self.model.buildPhotoEngine()
//        } else { self.model.buildScrollView()
//        }
      })
      ])
  }
  
  
  
  func buildScreenObjectsArray() {
    screenImages = [imgSequence]
    screenButtons = [] //[btnCancel, btnHelp]   removing these becase we're using interface builder
    screenObjects = [screenLabels, screenTxtBoxes, screenButtons, screenImages, screenOther].flatMap({$0})
    screenObjects.map({$0.translatesAutoresizingMaskIntoConstraints = false})
    
  }
  
  // MARK: -- required functions
  override func viewDidLoad() {
    PC("RecallViewController")
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
  
  override func viewWillDisappear(animated: Bool) {
    if let timer = self.model.scheduledTimer {
      timer.invalidate()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  // MARK: -- Constraints
  func buildConstraints() {
    let view = self.view
//    
//    view.snp_makeConstraints { (make) -> Void in
//      make.leftMargin.equalTo(15)
//      make.rightMargin.equalTo(15)
//      make.bottomMargin.equalTo(15)
//    }
    
//    viewNavigationBar.snp_makeConstraints { (make) -> Void in
//      make.top.equalTo(view.snp_topMargin).offset(30)
//      make.left.equalTo(view.snp_left)
//      make.right.equalTo(view.snp_right)
//      make.height.equalTo(50)
//    }
//    
    imgSequence.snp_makeConstraints { (make) -> Void in
      make.width.equalTo(300)
      make.height.equalTo(300)
      make.centerX.equalTo(view.snp_centerX)
      make.centerY.equalTo(view.snp_centerY)
    }
//    imgSequence.layer.cornerRadius = imgSequence.bounds.width / 2
    imgSequence.clipsToBounds = true
    
    scrlDots.snp_makeConstraints { (make) -> Void in
      make.left.equalTo(view.snp_left).offset(15)
//      make.centerX.equalTo(view.snp_centerX)
      make.top.equalTo(viewNavigationBar.snp_bottom).offset(15)
      make.width.equalTo(50)
      make.bottom.equalTo(view.snp_bottom).inset(15)
    }
//    scrlDots.backgroundColor = gray_light q q
    scrlDots.contentSize = scrlDots.bounds.size
    
  }
  
  
  
}  // end of class
