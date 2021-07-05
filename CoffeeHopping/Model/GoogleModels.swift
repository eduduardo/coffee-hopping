//
//  GoogleModels.swift
//  CoffeeHopping
//
//  Created by Eduardo Ramos on 04/07/21.
//

import Foundation
import ObjectMapper

class GooglePhoto: Mappable, Equatable {
    static func == (lhs: GooglePhoto, rhs: GooglePhoto) -> Bool {
        return lhs.photoReference == rhs.photoReference
    }
    
    var photoReference: String?
    var height: Int?
    var width: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        photoReference      <- map["photo_reference"]
        height              <- map["height"]
        width               <- map["width"]
    }
}


class GoogleReview: Mappable {
    var author: String?
    var avatar: String?
    var rating: Float?
    var text: String?
    var timeRelative: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        author          <- map["author_name"]
        avatar          <- map["profile_photo_url"]
        rating          <- map["rating"]
        text            <- map["text"]
        timeRelative    <- map["relative_time_description"]
    }
}

class Place: Mappable {
    var name: String?
    var placeId: String?
    var latitude: Double!
    var longitude: Double!
    var status: String?
    var address: String?
    var phone: String?
    var rating: Float?
    var reviews: [GoogleReview]?
    var photos: [GooglePhoto]?
    var priceLevel: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name            <- map["name"]
        placeId         <- map["place_id"]
        latitude        <- map["geometry.location.lat"]
        longitude       <- map["geometry.location.lng"]
        status          <- map["business_status"]
        address         <- map["vicinity"]
        phone           <- map["formatted_phone_number"]
        rating          <- map["rating"]
        reviews         <- map["reviews"]
        photos          <- map["photos"]
        priceLevel      <- map["price_level"]
    }
}

class Response: Mappable {
    var results: [Place]?
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        results     <- map["results"]
    }
}

class PlaceDetail: Mappable {
    var result: Place?
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        result      <- map["result"]
    }
}
