//
//  PersonEntity+CoreDataProperties.swift
//  cse423f18_SkillsModuleProgram-Archer_Patrick
//
//  Created by Patrick Archer on 11/20/18.
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//
//

import Foundation
import CoreData


extension PersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var image: NSData?

}
