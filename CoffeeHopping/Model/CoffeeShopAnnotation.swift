//
//  CoffeeShopAnnotation.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 03/07/21.
//

import Foundation
import MapKit

class CoffeeShopAnnotation : MKPointAnnotation  {
    
    let coffeeShop: CoffeeShop
    
    init(_ coffeeShop: CoffeeShop){
        self.coffeeShop = coffeeShop
        super.init()
        self.coordinate = CLLocationCoordinate2DMake(coffeeShop.latitude, coffeeShop.longitude)
        self.title = coffeeShop.name
    }
}
