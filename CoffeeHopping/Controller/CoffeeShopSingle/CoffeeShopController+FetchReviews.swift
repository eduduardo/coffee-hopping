//
//  CoffeeShopController+FetchReviews.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 04/07/21.
//

import Foundation
import CoreData
import UIKit

extension CoffeeShopController {
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Review> = Review.fetchRequest()
        let predicate = NSPredicate(format: "coffeeShop == %@", place)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        reviewsFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: dataController.viewContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        reviewsFetchController.delegate = self
        
        do {
            try reviewsFetchController.performFetch()
        } catch {
            fatalError("Error while fetching reviews \(error.localizedDescription)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            reviewsTable.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            reviewsTable.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            reviewsTable.reloadRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
}
