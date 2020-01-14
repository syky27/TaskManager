//
//  CategoryViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 14/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import CoreData

class CategoryViewModel {
//    var categories = [DBCategory]()
    var fetchedRC: NSFetchedResultsController<DBCategory>!

    init() {
        let request: NSFetchRequest<DBCategory> = DBCategory.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(DBCategory.name),
                                    ascending: true,
                                    selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]

        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request,
                                                   managedObjectContext: CoreDataManager.shared.context,
                                                   sectionNameKeyPath: #keyPath(DBCategory.name),
                                                   cacheName: nil)

            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
