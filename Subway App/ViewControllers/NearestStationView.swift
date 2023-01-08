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

class NearestStationView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    var stationList: [StationTabel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.mapType = MKMapType.hybrid
        
        
        //location
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
        
        getStations()
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
            var startPoint = displayGPSPosition(latitude!, longitude!)
            
            var endPoint = getNearstStation(longitude: latitude!, latitude: longitude!)
            
            if(startPoint != nil && endPoint != nil){
                drawRouteToNearestStation(start: startPoint!, end: endPoint!)
            }
        }

    }
    
    func  displayGPSPosition(_ latitude: Double, _ longitude: Double ) -> MKPointAnnotation?{
        
        let cordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cordinate
        annotation.title = "Position"
        annotation.subtitle = "current GPS position"
        
        mapView.addAnnotation(annotation)
        mapView.setCenter(cordinate, animated: false)

        return annotation
        
        //mapView.setCenter(cordinate, animated: false)
    }
    
    
    func getNearstStation(longitude: Double, latitude: Double) -> MKPointAnnotation?{
        
        var positionGPS = CLLocation(latitude: longitude, longitude: latitude)
        
        
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
                    
                    print("current distanze: " + curentDistanze.description)
                    print("previus distanue: " + previosDistance.description)
                    print("previus Location:" + previosLocation.description)
                    print("currentLocation:" + currenLocation.description)
                    print("gps location:" + positionGPS.description)
                    print("")
                    print("")
                    print("")
                    
                    
                    if(curentDistanze < previosDistance){
                        savedStation = station
                    }
                }
                
                return drawNearestStation(station: savedStation)
            }else{
                print("list empty")
            }
            
        }else{
            print("list is nil")
        }
        return nil
    }
    
    func drawNearestStation(station: StationTabel) -> MKPointAnnotation{
        var cordinate = CLLocationCoordinate2D(latitude: station.cordinates?.latitude ?? 0.0, longitude: station.cordinates?.longitude ?? 0.0 )
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cordinate
        annotation.title = station.name
        annotation.subtitle = String(station.subwayLine)
    
        self.mapView.addAnnotation(annotation)
        return annotation
    }
    
    func drawRouteToNearestStation(start: MKPointAnnotation, end: MKPointAnnotation ){
        var request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end.coordinate))
        
        var directions = MKDirections(request: request)
        
        directions.calculate(){responce, error in
            print("")
            print("responce:" + (responce?.description ?? "kein responce"))
            print("responce:" + (responce?.debugDescription ?? "kein responce debug"))
            print("responce:" + (responce?.routes.debugDescription ?? "keine debug description"))
            print("responce:" + (responce?.routes.description ?? "keine routs devug"))
            print("error " + error.debugDescription)
            
            print("routs count: " + (responce?.routes.count.description ?? "no routs"))
            
            guard(responce != nil) else{
                print("responce is nil")
                return
            }
            guard(responce?.routes.count != 0) else{
                print("no Routes")
                return
            }
            guard(responce?.routes[0].polyline != nil)else{
                print("no polyline")
                return
            }
            
            var routePolyLine: MKPolyline = (responce?.routes[0].polyline)!
            
            self.mapView.addOverlay(routePolyLine)
            
            
            
        }
         
         
        
       // mapView.addOverlay(directions)
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

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:")
        print(error)
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay ) -> MKOverlayRenderer{
        print("render:")
        print(overlay)
        var plRenderer: MKPolylineRenderer
        if(overlay is MKPolyline){
            plRenderer = MKPolylineRenderer(overlay: overlay)
            
            plRenderer.strokeColor = UIColor.red
            
            plRenderer.lineWidth = 3
            return plRenderer
        }else{
            return MKPolylineRenderer()
        }
    }


}
