//
//  ViewController.swift
//  Realtime Map
//
//  Created by Victor Idongesit on 28/08/2018.
//  Copyright © 2018 Victor Idongesit. All rights reserved.
//


import UIKit
import PusherSwift
import Alamofire
import GoogleMaps
import MapKit


class ViewController: UIViewController, GMSMapViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
 
    var carMarker: GMSMarker!
    let locationManager = CLLocationManager()
    var pusher: Pusher!
    
    var currentDirection: CLLocationDirection = CLLocationDirection(exactly: 0.0)!
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var carDirection: Double = 0
    
    @IBOutlet weak var infoLabel: UITextView!
    @IBOutlet weak var mapView: GMSMapView!
    let destinationLocation = CLLocationCoordinate2D(latitude: 6.569884, longitude: 3.373243 ) // Amity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            print("Enabled location services")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestAlwaysAuthorization()
            if let currentLocation = locationManager.location?.coordinate {
                carMarker = GMSMarker(position: currentLocation)
                carMarker.icon = UIImage(named: "resizedGat")
                carMarker.title = "Here"
                carMarker.map = mapView
                carMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                mapView.animate(toZoom: 20)
                dropPin(at: currentLocation, on: mapView, withTitle: "Here")
            }
            dropPin(at: destinationLocation, on: mapView, withTitle: "Amity")
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        } else {
            print("Location services not enabled")
        }
        
        self.mapView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = location.coordinate
        NetworkCalls.shared.drawRoute(from: center, to: destinationLocation, on: mapView, completion: { vehicleLocation, navInstruction, direction in
            self.infoLabel.text = navInstruction?.htmlToString
            if let carLocation = vehicleLocation {
                self.updateMarker(coordinates: carLocation, degrees: direction, duration: 0.5, marker: self.carMarker)
                self.carDirection = direction
                self.mapView.animate(toBearing: direction)
                self.mapView.animate(toLocation: carLocation)
            } else {
                print("Executing the else statement")
                self.updateMarker(coordinates: center, degrees: direction, duration: 0.5, marker: self.carMarker)
                self.mapView.animate(toLocation: center)
            }
            self.dropPin(at: self.destinationLocation, on: self.mapView, withTitle: "Amity")
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.animate(toBearing: carDirection)
    }

    public func dropPin(at point: CLLocationCoordinate2D, on mapView: GMSMapView, withTitle title: String, image: UIImage? = nil, rotate: Double = 0) {
        let pin = GMSMarker(position: point)
        
        pin.title = title
        
        if let markerIcon = image {
            pin.icon = markerIcon
        }
        pin.map = mapView
    }
    
    func updateMarker(coordinates: CLLocationCoordinate2D, degrees: CLLocationDegrees, duration: Double, marker: GMSMarker) {
        // Keep Rotation Short
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        // marker.rotation = degrees
        CATransaction.commit()
        
        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        marker.position = coordinates
        
        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordinates)
        mapView.animate(with: camera)
        
        CATransaction.commit()
    }
    
    @IBAction func simulateMovement(_ sender: Any) {
    }
}


