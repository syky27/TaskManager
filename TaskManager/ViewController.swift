//
//  ViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 22/12/2019.
//  Copyright © 2019 AJTY. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    private var fetchedRC: NSFetchedResultsController<DBCategory>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red

        let category = DBCategory(context: CoreDataManager.shared.context)
        category.name = "Test"
        CoreDataManager.shared.saveContext()

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
