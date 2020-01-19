//
//  DBTask+CoreDataProperties.swift
//  
//
//  Created by Tomas Sykora, jr. on 19/01/2020.
//
//

import Foundation
import CoreData

extension DBTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBTask> {
        return NSFetchRequest<DBTask>(entityName: "DBTask")
    }

    @NSManaged public var deadline: Date?
    @NSManaged public var done: Bool
    @NSManaged public var name: String?
    @NSManaged public var notify: Bool
    @NSManaged public var category: DBCategory?

}
