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
    
    var stationList: [StationTabel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        mapView.mapType = MKMapType.hybrid
        
  
        
        //location
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
        
        
        getStations()
        
        //drawStations()
        
       
        
       
        /*
        print("stations")
        print(stationList)
         */
        
       // locationManager?.requestLocation()
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
            
            getNearstStation(longitude: latitude!, latitude: longitude!)
            
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
    
    
    func getNearstStation(longitude: Double, latitude: Double){
        var positionGPS = CLLocation(latitude: latitude, longitude: longitude)
        
        if(stationList != nil ){
            if(stationList!.count > 0){
                
                var firstStation = CLLocation(latitude: stationList![0].cordinates?.latitude ?? 0.0, longitude: stationList![0].cordinates?.longitude ?? 0.0)
                //var distance = positionGPS.distance(from: firstStation)
                
                var savedStation: StationTabel = stationList![0] ?? StationTabel()
                var previosDistance: Double
                
                for station in stationList!{
                    var previosLocation = CLLocation(latitude: savedStation.cordinates?.latitude ?? 0.0, longitude: savedStation.cordinates?.longitude ?? 0.0)
                    var currenLocation = CLLocation(latitude: station.cordinates?.latitude ?? 0.0, longitude: station.cordinates?.longitude ?? 0.0)
                    previosDistance = positionGPS.distance(from: previosLocation)
                    
                    var curentDistanze = positionGPS.distance(from: currenLocation)
                    
                    if(curentDistanze < previosDistance){
                        savedStation = station
                    }
                }
                
                drawNearestStation(station: savedStation)
            }else{
                print("list empty")
            }
            
        }else{
            print("list is nil")
        }
        
    }
    
    func drawNearestStation(station: StationTabel){
        var cordinate = CLLocationCoordinate2D(latitude: station.cordinates?.latitude ?? 0.0, longitude: station.cordinates?.longitude ?? 0.0 )
        
        print("station")
        print(station)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cordinate
        annotation.title = station.name
        annotation.subtitle = String(station.subwayLine)
        
        
        
        self.mapView.addAnnotation(annotation)
    }
    
    func getStations(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            let stations = database.getAllStations()
            
            self.stationList = [StationTabel]()
            
            for station in stations{
                self.stationList?.append(station)
              // print(station)
            }
            
           // print(self.stationList)
            self.locationManager?.requestLocation()
        }
    }
    
    /*
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
    */

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:")
        print(error)
        
    }


}
