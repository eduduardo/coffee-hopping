//
//  CoffeesVisitedViewController.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 03/07/21.
//

import Foundation
import UIKit
import CoreData

class CoffeesVisitedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<CoffeeShop>!
    
    var dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        changeTabBadgeNumber(badgeValue: count)

        setupTableCountOrEmpty(tableView: tableView, count: count, emptyText: "You should review atleast one coffee shop!")
                
        return count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let coffeeShop = fetchedResultsController.object(at: indexPath)
            coffeeShop.visitedAt = nil
            dataController.save()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coffeeCell", for: indexPath)
        
        let coffeeShop = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = coffeeShop.name
        
        let firstPhoto = coffeeShop.photos?.allObjects.first as? Photo
        if firstPhoto != nil && firstPhoto?.media != nil {
            cell.imageView?.image = UIImage(data: firstPhoto!.media!)
            cell.imageView?.contentMode = .scaleToFill
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-​MM-dd"
        let formatteddate = formatter.string(from: coffeeShop.visitedAt!)
    
        cell.detailTextLabel?.text = "Visited at: \(formatteddate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coffeeShop = fetchedResultsController.object(at: indexPath)
        navigateToCoffeePage(coffeeShop)
    }
}
