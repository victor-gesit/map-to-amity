//
//  NetworkCalls.swift
//  Realtime Map
//
//  Created by Victor Idongesit on 29/08/2018.
//  Copyright © 2018 Victor Idongesit. All rights reserved.
//

import Foundation
import Alamofire
import GoogleMaps
import SwiftyJSON

class NetworkCalls {
    static var shared = NetworkCalls()
    private init() {}
    
    public func drawRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, on mapView: GMSMapView){
        let origin = "\(start.latitude),\(start.longitude)"
        let destination = "\(end.latitude),\(end.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyB3GnTQvhL9xbHuUof1xZNxY9dmJ6LEacc"
        
        var polyline: GMSPolyline?
        Alamofire.request(url).responseJSON { response in
            print(response, "RESPONSE")
            do {
                let json = try JSON(data: response.data ?? Data())
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    
                    polyline = GMSPolyline(path: path)
                    polyline?.strokeColor = .black
                    polyline?.strokeWidth = 4.0
                    polyline?.map = mapView
                }
            } catch let e {
                print("Error", e)
                polyline = nil
            }
        }
    }
    
}
