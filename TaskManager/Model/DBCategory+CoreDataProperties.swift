//
//  DBCategory+CoreDataProperties.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//
//

import Foundation
import CoreData

extension DBCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBCategory> {
        return NSFetchRequest<DBCategory>(entityName: "DBCategory")
    }

    @NSManaged public var color: String?
    @NSManaged public var name: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension DBCategory {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: DBTask)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: DBTask)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
