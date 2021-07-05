//
//  PlaceAutocompleteResponse.swift
// https://github.com/honghaoz/Swift-Google-Maps-API/blob/master/Source/Google%20Places%20API/PlaceAutocompleteResponse.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-13.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//
import Foundation
import ObjectMapper

public struct PlaceAutocompleteResponse: Mappable {
    public var status: String?
    public var errorMessage: String?
    
    public var predictions: [Prediction] = []
    
    public init() {}
    public init?(map: Map) { }
    
    public mutating func mapping(map: Map) {
        status <- (map["status"], EnumTransform())
        errorMessage <- map["error_message"]
        
        predictions <- map["predictions"]
    }
    
    /**
     *  Prediction
     */
    public struct Prediction: Mappable {
        public var description: String?
        public var place: Place?
        public var terms: [Term] = []
        public var types: [String] = []
        public var matchedSubstring: [MatchedSubstring] = []
        
        public init() {}
        public init?(map: Map) { }
        
        public mutating func mapping(map: Map) {
            description <- map["description"]
            place <- (map["place_id"], TransformOf(fromJSON: { (json) -> Place? in
                if let placeId = json {
                    return Place.placeID(id: placeId)
                } else {
                    return nil
                }
                }, toJSON: { (place) -> String? in
                    switch place {
                    case .none:
                        return nil
                    case .some(let place):
                        switch place {
                        case .placeID(id: let id):
                            return id
                        default:
                            return nil
                        }
                    }
            }))
            
            terms <- map["terms"]
            types <- map["types"]
            matchedSubstring <- map["matched_substrings"]
        }
    }
    
    /**
     *  Term
     */
    public struct Term: Mappable {
        public var offset: Int?
        public var value: String?
        
        public init() {}
        public init?(map: Map) { }
        
        public mutating func mapping(map: Map) {
            offset <- map["offset"]
            value <- map["value"]
        }
    }
    
    /**
     *  MatchedSubstring
     */
    public struct MatchedSubstring: Mappable {
        public var length: Int?
        public var offset: Int?
        
        public init() {}
        public init?(map: Map) { }
        
        public mutating func mapping(map: Map) {
            length <- map["length"]
            offset <- map["offset"]
        }
    }
}
