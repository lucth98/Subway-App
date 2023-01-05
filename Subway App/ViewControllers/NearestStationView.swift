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
        
        drawStations()
        
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
        
        //mapView.setCenter(cordinate, animated: false)
    }
    
    func drawStations(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            let stations = database.getAllStations()
            
            for station in stations{
                
                let cordinate = CLLocationCoordinate2DMake(station.cordinates?.latitude ?? 0.0, station.cordinates?.longitude ?? 0.0)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = cordinate
                annotation.title = station.name
                annotation.subtitle = String(station.subwayLine)
                
                
                
                self.mapView.addAnnotation(annotation)
            }
            
        }
    }
    

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:")
        print(error)
        
    }


}
