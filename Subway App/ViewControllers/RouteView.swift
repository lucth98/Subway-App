//
//  RouteView.swift
//  Subway App
//
//  Created by Lucas on 28.12.22.
//

import Foundation
import UIKit
import MapKit

class RouteView: UIViewController, MKMapViewDelegate {
    
    var route: Route?
    var correntLine: Int = 0
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Display Route"
        
        mapView.mapType = MKMapType.hybrid
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: CLLocationDistance(50000))
        
        var corrdinatesOfVienna = CLLocationCoordinate2D(latitude:ShowSubwayMapView.latitudeVienna , longitude: ShowSubwayMapView.longitudeVienna)
        mapView.setCenter(corrdinatesOfVienna, animated: false)
        
        drawRoute()
    }
    
    func drawRoute(){
        guard(route != nil) else{
            return
        }
        
        for station in route!.stations{
            /*
            print("print Station")
            print(station)
            */
            let cordinate = CLLocationCoordinate2DMake(station.cordinates?.latitude ?? 0.0, station.cordinates?.longitude ?? 0.0)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = cordinate
            annotation.title = station.name
            
            var subtitel = "Lines:" //+ String(station.subwayLines.description)
            for line in station.subwayLines{
                subtitel += "U" + line.description + " "
            }
            
            subtitel += "\n latitude:" + cordinate.latitude.description
            subtitel += "\n longitude:" + cordinate.longitude.description
            
            
            annotation.subtitle = subtitel
            
            mapView.addAnnotation(annotation)
        }
        
        for i in stride(from: 0, to: route!.stations.count - 1 , by: 1){
            
            var locations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
            
            locations.append(CLLocationCoordinate2D(latitude:  route!.stations[i].cordinates!.latitude, longitude: route!.stations[i].cordinates!.longitude))
            
            locations.append(CLLocationCoordinate2D(latitude:  route!.stations[i+1].cordinates!.latitude , longitude: route!.stations[i+1].cordinates!.longitude))
            
            var polyline = MKPolyline(coordinates: locations, count: locations.count
            )
          
            print(route!.stations[i].name)
            print("i =" + i.description)
            self.correntLine =  route?.lineNumbers[i] ?? 0 //(route?.stations[i].subwayLines[0])!// richtige farbe
            
            self.mapView.addOverlay(polyline)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay ) -> MKOverlayRenderer{
        // print("render:")
        // print(overlay)
        var plRenderer: MKPolylineRenderer
        if(overlay is MKPolyline){
            plRenderer = MKPolylineRenderer(overlay: overlay)
            
            switch (correntLine){
            case 1:
                plRenderer.strokeColor = UIColor.red
            case 2:
                plRenderer.strokeColor = UIColor.purple
            case 3:
                plRenderer.strokeColor = UIColor.orange
            case 4:
                plRenderer.strokeColor = UIColor.green
            case 6:
                plRenderer.strokeColor = UIColor.brown
                
            default:
                plRenderer.strokeColor = UIColor.blue
            }
            
            plRenderer.lineWidth = 3
            return plRenderer
        }else{
            return MKPolylineRenderer()
        }
    }
}
