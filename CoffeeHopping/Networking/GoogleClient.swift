//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 26/06/21.
//

import Foundation
import Alamofire
import ObjectMapper
import UIKit

class GoogleClient {
    static let API_KEY = ""
    
    static let shared = GoogleClient()
    
    enum Endpoint {
        static let base = "https://maps.googleapis.com/maps/api/place/"
        static let radius = 1000
        case searchCoffeeShops(Double, Double)
        case placeDetails(String)
        case placePhoto(String)
        
        var urlString: String {
            switch self {
            case .searchCoffeeShops(let latitude, let longitude):
                return Endpoint.base +
                    "search/json" +
                    "?key=\(GoogleClient.API_KEY)" +
                    "&location=\(latitude),\(longitude)" +
                    "&type=cafe&fields=geometry" +
                    "&radius=\(Endpoint.radius)"
            case .placeDetails(let placeId):
                return Endpoint.base +
                    "details/json" +
                    "?key=\(GoogleClient.API_KEY)" +
                    "&place_id=\(placeId)" +
                    "&types=cafe&sensor=true&fields=name,rating,formatted_phone_number,reviews,photos"
            case .placePhoto(let photoReference):
                return Endpoint.base +
                    "photo" +
                    "?key=\(GoogleClient.API_KEY)" +
                    "&photoreference=\(photoReference)" +
                    "&maxwidth=\(Int(UIScreen.main.bounds.width))"
                
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    class func getCoffeeShops(_ latitude: Double, _ longitude: Double, completion: @escaping ([Place]?, Error?) -> Void){
        AF.request(Endpoint.searchCoffeeShops(latitude, longitude).url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    let locations = Mapper<Response>().map(JSON: json)
                    completion(locations?.results, nil)
                }
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }
    
    class func getPlaceDetail(_ placeId: String, completion: @escaping (Place?, Error?) -> Void){
        AF.request(Endpoint.placeDetails(placeId).url, method: .get).responseJSON { response in
            switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let locations = Mapper<PlaceDetail>().map(JSON: json)
                        completion(locations?.result, nil)
                    }
                    break
                case .failure(let error):
                    completion(nil, error)
                    break
            }
        }
    }
    
    class func donwloadImage(_ photoReference: String, completion: @escaping (Data?, Error?) -> Void) {
        let redirector = Redirector(behavior: .follow)
        AF.request(Endpoint.placePhoto(photoReference).url ,method: .get).redirect(using: redirector).response { response in
            switch response.result {
                case .success(let responseData):
                    completion(responseData, nil)
                    break
                    
                case .failure(let error):
                    completion(nil, error)
                    break
            }
        }
    }
}
