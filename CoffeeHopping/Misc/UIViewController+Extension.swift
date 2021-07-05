//
//  UIViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 27/06/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertModal(_ title: String, _ message: String, completion: @escaping (UIAlertAction) -> Void = { _ in }){
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                completion(action)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func navigateToCoffeePage(_ coffeeShop: CoffeeShop){
        let coffeeShopController = storyboard?.instantiateViewController(identifier: "CoffeeShop") as! CoffeeShopController
        coffeeShopController.title = coffeeShop.name
        coffeeShopController.place = coffeeShop
        navigationController?.pushViewController(coffeeShopController, animated: true)
    }
    
    func changeTabBadgeNumber(badgeValue: Int){
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[1]
            tabItem.badgeValue = badgeValue > 0 ? "\(badgeValue)" : nil
        }
    }
    
    func toggleLoading(_ loading: Bool = true){
        if loading == false {
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
            return
        }
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(loadingVC, animated: false, completion: nil)
        }
        
    }
    
    func setupTableCountOrEmpty(tableView: UITableView, count: Int, emptyText: String) {
        if count <= 0 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = emptyText
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
    }
}
