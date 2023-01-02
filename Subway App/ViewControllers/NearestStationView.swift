//
//  NearestStationViewController.swift
//  Subway App
//
//  Created by Lucas on 28.12.22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class NearestStationView: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        mapView.mapType = MKMapType.hybrid
        
        
        
        //location
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
        
        
        locationManager?.requestLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation = locations.last
        print("")
        print("cordinatene:")
        print(lastLocation?.coordinate.latitude)
        print(lastLocation?.coordinate.longitude)
        
        var latitude: Double? = lastLocation?.coordinate.latitude
        var longitude: Double? = lastLocation?.coordinate.longitude
        
        if(latitude != nil && longitude != nil){
            displayGPSPosition(latitude!, longitude!)
        }
        
        
    }
    
    func  displayGPSPosition(_ latitude: Double, _ longitude: Double ){
        
        let cordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cordinate
        annotation.title = "Position"
        annotation.subtitle = "current GPS position"
        
        
        mapView.addAnnotation(annotation)
        
        mapView.setCenter(cordinate, animated: false)
    }
    

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:")
        print(error)
        
    }


}
