//
//  ViewController.swift
//  Realtime Map
//
//  Created by Victor Idongesit on 28/08/2018.
//  Copyright © 2018 Victor Idongesit. All rights reserved.
//

//
// Import libraries
//
import UIKit
import PusherSwift
import Alamofire
import GoogleMaps
import MapKit


class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D) {
        self.coordinate = location
        self.title = pinTitle
        self.subtitle = pinSubTitle
    }
}


//
// View controller class
//
class ViewController: UIViewController, GMSMapViewDelegate, MKMapViewDelegate {
    // Marker on the map
    var locationMarker: GMSMarker!
    
    // Default starting coordinates
    var longitude = -122.088426
    var latitude  = 37.388064
    
    var pusher: Pusher!
    @IBOutlet weak var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let sourceLocation = CLLocationCoordinate2D(latitude: 6.569884, longitude: 3.373243 )
        let destinationLocation = CLLocationCoordinate2D(latitude: 6.553705, longitude: 3.366297 )
        
        let sourcePin = CustomPin(pinTitle: "Home", pinSubTitle: "Amity 2.0", location: sourceLocation)
        let destinationPin = CustomPin(pinTitle: "Epic Tower", pinSubTitle: "AWD Building", location: destinationLocation)
        
        let camera = GMSCameraPosition.camera(withLatitude:latitude, longitude:longitude, zoom:15.0)
        mapView.camera = GMSCameraPosition(target: sourceLocation, zoom: 120, bearing: 90, viewingAngle: 90)
        let sourcePlaceMark = GMSMarker(position: sourceLocation)
        sourcePlaceMark.title = "Home"
        sourcePlaceMark.map = mapView
        let destinationPlaceMark = GMSMarker(position: destinationLocation)
        destinationPlaceMark.title = "Epic Tower"
        destinationPlaceMark.map = mapView

        
        self.mapView.delegate = self
    
        NetworkCalls.shared.drawRoute(from: sourceLocation, to: destinationLocation, on: mapView)
    }
    
    //
    // Send a request to the API to simulate GPS coords
    //
    @IBAction func simulateMovement(_ sender: Any) {
    }
    
    //
    // Connect to pusher and listen for events
    //
    private func listenForCoordUpdates() {
    }
}
