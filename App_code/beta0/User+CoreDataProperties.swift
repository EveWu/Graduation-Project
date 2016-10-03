//
//  User+CoreDataProperties.swift
//  beta0
//
//  Created by wu xiao yue on 4/9/16.
//  Copyright © 2016 eve. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var userAge: NSNumber?
    @NSManaged var userHeight: NSNumber?
    @NSManaged var userId: String?
    @NSManaged var userImage: NSData?
    @NSManaged var userName: String?
    @NSManaged var userSex: NSNumber?
    @NSManaged var userWeight: NSNumber?
    @NSManaged var userBust: NSNumber?
    @NSManaged var userWaist: NSNumber?
    @NSManaged var userHip: NSNumber?

}
