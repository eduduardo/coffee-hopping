//
//  CoffeesVisited+Fetch.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 04/07/21.
//

import Foundation
import CoreData

extension CoffeesVisitedViewController {
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<CoffeeShop> = CoffeeShop.fetchRequest()
        let predicate = NSPredicate(format: "visitedAt != nil")
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: dataController.viewContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error while fetching reviews \(error.localizedDescription)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
}
