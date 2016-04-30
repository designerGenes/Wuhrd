//
//  randomizer.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 3/7/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import Foundation
import UIKit

public func rollDice(sides: Int) -> Int {
  let out = arc4random_uniform(UInt32(sides)) % UInt32(sides)
  return Int(out)
}


public func flipCoin() -> Int {
  let out = arc4random_uniform(2) % UInt32(2)
  return Int(out)
}

func flipCoin(outcomes: [String]) -> String? {
  let out = Int(arc4random_uniform(2) % UInt32(2))
  if out > (outcomes.count-1) || out == 0 { flipCoin(outcomes) }
  return outcomes[out]
}