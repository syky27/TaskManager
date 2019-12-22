//
//  DBTask+CoreDataProperties.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 22/12/2019.
//  Copyright © 2019 AJTY. All rights reserved.
//
//

import Foundation
import CoreData

extension DBTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBTask> {
        return NSFetchRequest<DBTask>(entityName: "DBTask")
    }

    @NSManaged public var name: String?
    @NSManaged public var deadline: Date?
    @NSManaged public var done: Bool
    @NSManaged public var category: DBCategory?

}
