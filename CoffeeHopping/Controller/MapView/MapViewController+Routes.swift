//
//  MapViewController+Routes.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 03/07/21.
//

import Foundation
import MapKit

extension MapViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationForLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(red: 0.27, green: 0.80, blue: 0.69, alpha: 1.00)
        renderer.lineWidth = 2
        return renderer
    }
    
    func createRequest(_ place: CoffeeShop) -> MKDirections.Request? {
        guard let coordinate = CLLocationManager().location?.coordinate else { return nil }
        let destinationCoordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude)
        let origin = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: origin)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
            
        return request
    }
    
    func drawRoutes(_ place: CoffeeShop, sender: UIButton) {
        guard let request = createRequest(place) else { return }
        let directions = MKDirections(request: request)

        clearRoutes()
        
        DispatchQueue.main.async {
            sender.isEnabled = false
        }
            
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else { return }
            guard let route = response.routes.first else {
                return
            }
            
            let distanceKM = route.distance / 1000
            
            self.coffeeTitle.text = "\(self.coffeeTitle.text ?? "") - \(distanceKM)km"
            self.overlays.append(route.polyline)
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    func clearRoutes(){
        mapView.removeOverlays(overlays)
    }
}
