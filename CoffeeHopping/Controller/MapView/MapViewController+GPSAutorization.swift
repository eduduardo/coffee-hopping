//
//  MapViewController+GPSAutorization.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 04/07/21.
//

import Foundation
import MapKit

extension MapViewController {
    func toggleRandomButton(_ isEnable: Bool){
        randomButton.isEnabled = isEnable
        randomButton.backgroundColor = isEnable ? UIColor(red: 0.27, green: 0.80, blue: 0.69, alpha: 1.00) : .lightGray
    }
    func checkLocationServices(locationManager: CLLocationManager) {
        guard CLLocationManager.locationServicesEnabled() else {
            // Here we must tell user how to turn on location on device
            toggleRandomButton(false)
            showAlertModal("Autorize the location", "The random coffee button only works if you enable the location on the Settings of your phone")
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        checkAuthorizationForLocation()
    }
    
    func checkAuthorizationForLocation() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                mapView.showsUserLocation = true
                locationManager.startUpdatingLocation()
                toggleRandomButton(true)
                centerOnUserLocation()
                break
            case .denied:
                // Here we must tell user how to turn on location on device
                showAlertModal("Not autorized", "You will not be able to find random coffees near you")
                toggleRandomButton(false)
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // Here we must tell user that the app is not authorize to use location services
                break
            @unknown default:
                break
        }
    }
}
