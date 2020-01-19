//
//  DBCategory+CoreDataClass.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 22/12/2019.
//  Copyright © 2019 AJTY. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DBCategory)
public class DBCategory: NSManagedObject {

    func category() -> Category {
        return Category(categoryID: objectID, name: name ?? "", color: color ?? "")
    }
}
