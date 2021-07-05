//
//  ReviewViewController.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 03/07/21.
//

import Foundation
import UIKit

class ReviewViewController : UIViewController, UITextViewDelegate {
    
    var coffeeShop: CoffeeShop!
    @IBOutlet weak var textReview: UITextView!
    
    var dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textReview.delegate = self
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func publishReview(_ sender: Any) {
        let review = Review(context: dataController.viewContext)
        review.text = textReview.text
        review.createdAt = Date()
        review.coffeeShop = coffeeShop
        review.author = "myself"
        
        coffeeShop.visitedAt = Date()
        coffeeShop.reviews?.adding(review)
        
        dataController.save()
        
        showAlertModal("Review Published!", "Success") { [weak self] _ in
            let count = self?.dataController.countReviews() ?? 1
            
            self?.changeTabBadgeNumber(badgeValue: count)
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: keyboard functions
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
