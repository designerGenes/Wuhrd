//
//  Password+CoreDataProperties.swift
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

extension Password {
    @NSManaged var imageSequence: NSData?
    @NSManaged var isHighPriority: NSNumber?
    @NSManaged var passwordString: String?
    @NSManaged var siteTitle: String?
    @NSManaged var id: NSNumber?
    @NSManaged var images: NSOrderedSet?
    @NSManaged var switchType: String?

}
