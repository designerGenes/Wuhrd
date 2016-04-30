//
//  logoAnimator.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 3/10/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors

func assembleLogo(focus: ListViewController) {
  let fullName = "Wuhrd"
  for (index, character) in fullName.characters.enumerate() {
    let newCharacter = UILabel()
    newCharacter.text = "\(character)"
    newCharacter.textAlignment = .Center
    newCharacter.font = newCharacter.font.fontWithSize(33)
    newCharacter.font = UIFont(name: "Nexa Bold", size: 33)
    newCharacter.textColor = gray["white"]!
//    newCharacter.alpha = 0
//    newCharacter.frame.size = CGSize(width: 50, height: 50)
    newCharacter.center.y = 30

    newCharacter.center.x = (focus.view.frame.width / CGFloat(fullName.characters.count)) + (CGFloat(index) * newCharacter.frame.size.width)
    print(newCharacter.center)
    
    let testButton = UIButton()
    testButton.frame = CGRectMake(15, 15 + CGFloat(15 * index), 50, 50)
    testButton.backgroundColor = orange["light"]!
    testButton.alpha = 1
    
    let moveDown = CGAffineTransformMakeTranslation(0, 10)
    
    focus.view.addSubview(newCharacter)
    focus.view.bringSubviewToFront(newCharacter)
//    focus.view.addSubview(testButton)
    newCharacter.transform = moveDown
  }
}
