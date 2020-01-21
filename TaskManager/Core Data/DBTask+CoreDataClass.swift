import Foundation
import CoreData

@objc(DBTask)
public class DBTask: NSManagedObject {

    func task() -> Task {
        return Task(taskID: taskID,
                    name: name ?? "",
                    deadline: deadline ?? Date(),
                    done: done,
                    notify: notify,
                    category: Category(categoryID: category?.objectID,
                                       name: category?.name ?? "",
                                       color: category?.color ?? ""))
    }

    func replaceWith(task: Task) throws {
        taskID = task.taskID
        name = task.name
        deadline = task.deadline
        done = task.done
        notify = task.notify

        guard let context = managedObjectContext else { return }

        if let existingCategory = try context.existingObject(with: task.category.categoryID!) as? DBCategory {
             category = existingCategory
        }
    }
}
