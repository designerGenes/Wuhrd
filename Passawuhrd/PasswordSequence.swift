//
//  PasswordSequence.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/10/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import SwiftHEXColors
import UIKit
import CoreData




public let orderedDict: [String : String] = ["a" : "1", "e" : "2", "i" : "3", "o" : "4", "u" : "5"]  // in order of vowels
public let lookalikeDict: [String : String] = ["a" : "4", "e" : "3", "i" : "1", "o" : "0", "u" : "#"] // what the vowels look like
public let alphabetDict: [String : String] = ["a" : "1", "e" : "5", "i" : "9", "o" : "15", "u" : "21"] // in order of alphabet pos
public let similarDict: [String : String] = ["a" : "ay", "e" : "ee", "i" : "eye", "o" : "oh", "u" : "yu"] // sounds similar
public let switchTypes: [SwitchType: [String: String]] = [.ordered: orderedDict, .lookalike :lookalikeDict, .alphabet: alphabetDict, .similar: similarDict]

//   MARK: -- PASSWORD SEQUENCE

public class PasswordSequence {
  var siteTitle: String!
  var isHighPriority: NSNumber!
  var elements: [PasswordComponent]!
  var rawData: [NSData]?
  var switchType: SwitchType!
  
  init(size: Int, switchType: SwitchType) {
    PC("PasswordSequence")
    elements = [PasswordComponent]()
    for _ in 0..<size { elements.append(PasswordComponent(char: "∆", master: self))  }
    self.switchType = switchType
  }
  
  init(siteTitle: String, isHiPri: Bool, switchType: SwitchType, rawData: [NSData]? = nil) {
    PC("PasswordSequence")
    self.siteTitle = siteTitle
    self.isHighPriority = isHiPri
    self.switchType = switchType
    if let raw = rawData { self.rawData = raw }
  }
  
}





//   MARK: -- PASSWORD COMPONENT




public class PasswordComponent {
  var assocChar: String! {
    didSet {
      self.swapCharacter()
      var outString = ""
      for char in assocSequence.elements {
        outString += char.assocChar
      }
//      print(outString)
    }
  }
  var assocImage: UIImage?
  var assocCard: PasswordCard? {
    didSet {
      assocCard?.assocComponent = self
    }
  }
  var assocSequence: PasswordSequence
  
  func swapCharacter() {
    let switchType = assocSequence.switchType
    let tempChar = assocChar.lowercaseString
    if switchTypes[switchType!]![tempChar] != nil {
      print("Switching!")
      assocChar = switchTypes[switchType!]![tempChar]
    }
  }
  
  
  init(char: String, master: PasswordSequence) {
    PC("PasswordComponent")
    self.assocChar = char
    self.assocSequence = master
  }

  
}