//
//  ViewController.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 28/06/21.
//

import UIKit
import Alamofire
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var coffeeTitle: UILabel!
    @IBOutlet weak var randomButton: UIButton!
    
    var annotations = [CoffeeShopAnnotation]()
    
    let locationManager = CLLocationManager()
    
    var overlays = [MKOverlay]()
    
    var dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    
    struct Map {
        static let centerConfigKey = "map_center"
        static let reusePinId = "pin_map"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleLoading()
        setupMap()
        checkLocationServices(locationManager: locationManager)
        loadStoredCoffees()
        
        let count = dataController.countReviews()
        changeTabBadgeNumber(badgeValue: count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Setup functions
    
    func setupMap()
    {
        mapView.delegate = self
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.mapType = .mutedStandard
        mapView.showsBuildings = false
        
        loadCenterFromDefaults(mapView: mapView)
    }
    
    func loadStoredCoffees(){
        let coffeeShops = try? dataController.fetchAllCoffeeShops()
        
        for coffee in coffeeShops ?? [] {
            let annotation = CoffeeShopAnnotation(coffee)
            
            annotations.append(annotation)
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
            }
        }
        toggleLoading(false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
    
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Map.reusePinId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: Map.reusePinId)
            pinView!.canShowCallout = true
            pinView!.image = UIImage(named: "coffeePin")!.imageResize(sizeChange: CGSize(width: 45, height: 45))
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let annotationPin = view.annotation as! CoffeeShopAnnotation
            navigateToCoffeePage(annotationPin.coffeeShop)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationPin = view.annotation as? CoffeeShopAnnotation else {
            return
        }
        coffeeTitle.text = annotationPin.coffeeShop.name
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        clearRoutes()
        coffeeTitle.text = "Navigate to find coffee shops"
        mapView.selectedAnnotations = []
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.region.center
        let zoom = mapView.region.span
        
        saveCenterOnDefaults(center, zoom)
        GoogleClient.getCoffeeShops(center.latitude, center.longitude, completion: handleAddCoffeeShops(places:error:))
    }
    
    func handleAddCoffeeShops(places: [Place]?, error: Error?){
        guard error == nil else {
            showAlertModal("Error while finding coffee shops", error?.localizedDescription ?? "Unknow Error")
            return
        }
        
        for place in places ?? [] {
            let coffeeExists = try? dataController.getCoffeeBy(placeId: place.placeId ?? "")
            
            if coffeeExists != nil {
                continue
            }
            
            let coffeeShop = CoffeeShop(context: dataController.viewContext)
            coffeeShop.placeId = place.placeId
            coffeeShop.name = place.name
            coffeeShop.address = place.address
            coffeeShop.latitude = place.latitude
            coffeeShop.longitude = place.longitude
            coffeeShop.createdAt = Date()
            
            dataController.save()
            
            let annotation = CoffeeShopAnnotation(coffeeShop)
            
            annotations.append(annotation)
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func getRandomCoffeeShop() -> CoffeeShopAnnotation? {
        // select a random coffee which wasnt visited yet!
        return annotations.filter({ coffee -> Bool in
            return coffee.coffeeShop.visitedAt == nil
        }).randomElement()
    }
    
    @IBAction func drinkCoffee(_ sender: UIButton) {
        guard let randomCoffeeShop = getRandomCoffeeShop() else {
            return
        }
        toggleLoading()
        
        coffeeTitle.text = randomCoffeeShop.coffeeShop.name
        mapView.selectedAnnotations = [randomCoffeeShop]
        
        drawRoutes(randomCoffeeShop.coffeeShop, sender: sender)
        
        toggleLoading(false)
    }
    
    @IBAction func clearMap(){
        mapView.removeAnnotations(annotations)
        
        DispatchQueue.global(qos: .background).async {
            let coffeeShops = try? self.dataController.fetchAllCoffeeShops()
            for coffee in coffeeShops ?? [] {
                self.dataController.viewContext.delete(coffee)
                self.dataController.save()
            }
        }
    }
    
}
