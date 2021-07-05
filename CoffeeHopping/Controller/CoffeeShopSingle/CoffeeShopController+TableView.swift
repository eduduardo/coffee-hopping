//
//  CoffeeShopController+TableView.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 04/07/21.
//

import Foundation
import UIKit
import CoreData

extension CoffeeShopController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = reviewsFetchController.sections?[section].numberOfObjects ?? 0
        setupTableCountOrEmpty(tableView: tableView, count: count, emptyText: "No reviews founded :/")
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! CoffeeTableViewCell
        
        let review = reviewsFetchController.object(at: indexPath)
        cell.textLabel?.text = review.text ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let review = reviewsFetchController.object(at: indexPath)
            
            if review.author != "myself" {
                showAlertModal("Not Authorized", "You can only delete reviews made by you!")
                return
            }
            
            review.coffeeShop?.visitedAt = nil
            dataController.save()
            
            dataController.viewContext.delete(review)
            dataController.save()
        }
    }
}
