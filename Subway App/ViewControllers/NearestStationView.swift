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
        title = "Nearst Station"
        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.mapType = MKMapType.hybrid
        
        //test commit dsdhh
        //location
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
        
        getStations()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation = locations.last
        
        var latitude: Double? = lastLocation?.coordinate.latitude
        var longitude: Double? = lastLocation?.coordinate.longitude
        
        if(latitude != nil && longitude != nil){
            var startPoint = displayGPSPosition(latitude!, longitude!)
            
            var endPoint = getNearstStation(longitude: longitude!, latitude: latitude!)
            
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
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: CLLocationDistance(50000))
        
        return annotation
    }
    
    
    func getNearstStation(longitude: Double, latitude: Double) -> MKPointAnnotation?{
        
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
            
            guard(responce != nil) else{
                print(error?.localizedDescription)
                if(error != nil){
                    switch(error!.localizedDescription){
                    case "Zeitüberschreitung bei der Anforderung.":
                        self.drawAlert("Time Limit exceed for API call", "Internet is needet to draw the route")
                    case "Es besteht anscheinend keine Verbindung zum Internet.":
                        self.drawAlert("No Internet", "Internet is needet to draw the route")
                    case "Keine Route verfügbar":
                        self.drawAlert("No rout to nearest Station possible", "no possible route")
                    default:
                        self.drawAlert("Unknow route API error", error?.localizedDescription ?? "no Error returned")
                    }
                }else{
                    self.drawAlert("Unknow route API error",  "no Error returned")
                }
                
                return
            }
            guard(responce?.routes.count != 0) else{
                self.drawAlert("Unknow route API error", error?.localizedDescription ?? "no Error returned")
                return
            }
            guard(responce?.routes[0].polyline != nil)else{
                self.drawAlert("Route API Error", "Data from the apple routing is in the wrong format")
                return
            }
            
            var routePolyLine: MKPolyline = (responce?.routes[0].polyline)!
            
            self.mapView.addOverlay(routePolyLine)
        }
    }
    
    func getStations(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            self.stationList = database.getStationsAsArray()
            
            self.locationManager?.requestLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        drawAlert("GPS Erorr", error.localizedDescription)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay ) -> MKOverlayRenderer{
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
    
    func drawAlert(_ titleOfAlert:String,_ messageOfAlert:String){
        let alert:UIAlertController=UIAlertController(title: titleOfAlert,
                                                      message: messageOfAlert,
                                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
