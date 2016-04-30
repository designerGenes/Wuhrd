//
//  PWTableViewCell.swift
//  Passawuhrd
//
//  Created by Jaden Nation on 1/11/16.
//  Copyright © 2016 Jaden Nation. All rights reserved.
//

import UIKit
import CoreData

class PWTableViewCell: UITableViewCell {
  // MARK: -- outlets
  @IBOutlet weak var lblSiteTitle: UILabel!
  @IBOutlet weak var imgImportance: UIImageView!
 
  
  
  // MARK: -- variables
  var assocID: NSManagedObjectID!
  
  
  // MARK: -- custom functions
  func setProperties(label: String, priority: NSNumber, color: UIColor, id: NSManagedObjectID) {
    self.lblSiteTitle.text = label
    self.imgImportance.image = {priority == 1 ?  UIImage(named: "imgHighPriority") : UIImage(named: "imgLowPriority") }()
    self.backgroundColor = color
    self.assocID = id
  }
  
  
  // MARK: -- required functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
