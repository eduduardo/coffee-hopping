//
//  CoffeeShopController.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 03/07/21.
//

import Foundation
import UIKit
import MapKit
import CoreData

class CoffeeShopController : UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var place: CoffeeShop!
    
    @IBOutlet weak var coffeeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cellphoneLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var reviewsTable: UITableView!
    @IBOutlet weak var reviewButton: UIBarButtonItem!
    
    var dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    
    var reviewsFetchController: NSFetchedResultsController<Review>!
    
    var frame = CGRect.zero
    
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        reviewsTable.delegate = self
        reviewsTable.dataSource = self
        
        getPhotosAndInfos()
        
        setupFetchedResultsController()
        if place.visitedAt != nil {
            reviewButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getPhotosAndInfos(){
        if place.photos?.count ?? 0 > 0 {
            setupPhotosSlide()
            return
        }
        
        toggleLoading()
        
        GoogleClient.getPlaceDetail(place.placeId ?? "") { googlePlace, error in
            guard error == nil else {
                self.showAlertModal("Error while getting more coffee shop info", error?.localizedDescription ?? "Unknow error")
                self.toggleLoading(false)
                return
            }
            
            self.place.phone = googlePlace?.phone
            self.setupBasicInfos()
            
            for googleReview in googlePlace?.reviews ?? [] {
                if googleReview.text == nil || googleReview.text == "" {
                    continue
                }
                let review = Review(context: self.dataController.viewContext)
                review.author = googleReview.author
                review.avatar = googleReview.avatar
                review.rating = Int16(googleReview.rating ?? 0)
                review.text = googleReview.text
                review.coffeeShop = self.place
                
                self.dataController.save()
            }
            
            DispatchQueue.global(qos: .background).async {
                for googlePhoto in googlePlace?.photos ?? [] {
                    GoogleClient.donwloadImage(googlePhoto.photoReference ?? "a") { response, error  in
                        guard response != nil else {
                            return
                        }
                        
                        let photo = Photo(context: self.dataController.viewContext)
                        photo.coffeeShop = self.place
                        photo.media = response
                        photo.photoReference = googlePhoto.photoReference
                        
                        self.dataController.save()
                        
                        if googlePhoto == googlePlace?.photos?.last {
                            self.setupPhotosSlide()
                        }
                    }
                }
            }
            self.toggleLoading(false)
        }
    }
    
    func setupBasicInfos(){
        coffeeNameLabel.isHidden = false
        addressLabel.isHidden = false
        cellphoneLabel.isHidden = false
        
        coffeeNameLabel.text = place.name
        addressLabel.text = "Address: \(place.address ?? "Not informed")"
        cellphoneLabel.text = "Phone: \(place.phone ?? "Not informed")"
    }
    
    // https://www.ioscreator.com/tutorials/page-control-ios-tutorial
    func setupPhotosSlide(){
        let photos = try? dataController.getCoffeeShopPhotos(coffeeShop: place)
        let count = photos?.count ?? 0
        
        if count > 0 {
            var index = 0
            for photo in photos ?? [] {
                frame.origin.x = scrollView.frame.size.width * CGFloat(index)
                frame.size = scrollView.frame.size
                
                let imgView = UIImageView(frame: frame)
                imgView.image = UIImage(data: photo.media!)
                imgView.contentMode = .scaleAspectFit
                
                self.scrollView.addSubview(imgView)
                
                index += 1
            }
            
            scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(count)), height: scrollView.frame.size.height)
            scrollView.delegate = self
        }
    }
    
    
    // https://stackoverflow.com/questions/44997905/set-custom-coordinates-to-a-function-waze-integration
    func openWaze(location : CLLocationCoordinate2D) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            // Waze is installed. Launch Waze and start navigation
            let urlStr: String = "waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes"
            UIApplication.shared.open(URL(string: urlStr)!)
        }
        else {
            // Waze is not installed. Launch AppStore to install Waze app
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
        }
    }
    
    @IBAction func getDirections(_ sender: Any) {
        openWaze(location: CLLocationCoordinate2DMake(place.latitude, place.longitude))
    }
    
    @IBAction func rate(_ sender: Any) {
        let reviewController = storyboard?.instantiateViewController(identifier: "reviewModal") as! ReviewViewController
        reviewController.coffeeShop = self.place
        present(reviewController, animated: true, completion: nil)
    }
}
