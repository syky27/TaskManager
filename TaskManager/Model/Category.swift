//
//  Category.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 19/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import CoreData

struct Category {
    var categoryID: NSManagedObjectID?
    var name: String
    var color: String
}
