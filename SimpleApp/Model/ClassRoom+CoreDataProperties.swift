//
//  ClassRoom+CoreDataProperties.swift
//  SimpleApp
//
//  Created by Erik Flores on 2/18/18.
//  Copyright © 2018 Erik Flores. All rights reserved.
//
//

import Foundation
import CoreData


extension ClassRoom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassRoom> {
        return NSFetchRequest<ClassRoom>(entityName: "ClassRoom")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?

}
