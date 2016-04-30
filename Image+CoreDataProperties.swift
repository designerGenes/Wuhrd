//
//  Image+CoreDataProperties.swift
//  
//
//  Created by Jaden Nation on 1/16/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var image: NSData?
    @NSManaged var positionInChain: NSNumber?
    @NSManaged var owner: Password?

}
