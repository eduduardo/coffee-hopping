//
//  MapView+CenterDefault.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 04/07/21.
//

import Foundation
import UIKit
import MapKit

extension MapViewController {
    func saveCenterOnDefaults(_ center: CLLocationCoordinate2D, _ zoom: MKCoordinateSpan) {
        let location = [
            "latitude": Double(center.latitude),
            "longitude": Double(center.longitude),
            
            "latitudeDelta": Double(zoom.latitudeDelta),
            "longitudeDelta": Double(zoom.longitudeDelta)
        ]
        
        UserDefaults.standard.setValue(location, forKey: Map.centerConfigKey)
    }
    
    func centerOnUserLocation(){
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 20000, longitudinalMeters: 20000)
            mapView.setRegion(viewRegion, animated: false)
        }
    }
    
    func loadCenterFromDefaults(mapView: MKMapView){
        let storedLocation = UserDefaults.standard.dictionary(forKey: Map.centerConfigKey)
        guard let center = storedLocation as? [String: Double] else {
            centerOnUserLocation()
            
            return
        }
        
        let centerCoordinates = CLLocationCoordinate2DMake(center["latitude"]!, center["longitude"]!)
        let centerSpan = MKCoordinateSpan(latitudeDelta: center["latitudeDelta"]!, longitudeDelta: center["longitudeDelta"]!)
        
        mapView.setRegion(MKCoordinateRegion(center: centerCoordinates, span: centerSpan), animated: true)
    }
}
