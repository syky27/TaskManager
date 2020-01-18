//
//  DBTask+CoreDataClass.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 22/12/2019.
//  Copyright © 2019 AJTY. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DBTask)
public class DBTask: NSManagedObject {

    func task() -> Task {
        return Task(taskID: "#",
                    name: name ?? "",
                    deadline: deadline ?? Date(),
                    done: done,
                    category: Category(name: category?.name ?? "",
                                       color: category?.color ?? ""))
    }
}
