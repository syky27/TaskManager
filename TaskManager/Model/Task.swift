//
//  Task.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 19/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import CoreData

struct Task {
    var taskID: String?
    var name: String
    var deadline: Date
    var done: Bool
    var notify: Bool
    var category: Category
}
