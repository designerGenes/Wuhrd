//
//  constants.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 2/23/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors


public let PWCARD_SIZE: CGSize = CGSize(width: 90, height: 90)
public let PWCARD_BUFFER: CGFloat = 65

public let DEFAULT_MIN_PW_CHARS = 3


// view measurements
public let TOP_VIEW_BUFFER: CGFloat = 70

// ANLongButton constants
public let BUTTON_START_ANGLE: CGFloat = 45
public let BUTTON_TIME_PERIOD: NSTimeInterval = 0.75


// Password constants
public let rhymers = ["en", "ing", "ton", "ein", "oo", "ee", "er"]
public enum SwitchType: String {
  case lookalike = "A4E4"
  case ordered = "A1E2"
  case alphabet = "A1E5"
  case similar = "AyOh"
}

public enum PasswordFlag: String {
  case isHighPriority = "Hi Priority"
  case isMediumPriority = "Med Priority"
  case isLowPriority = "Lo Priority"
  case isHiddenFromList = "Private"
}