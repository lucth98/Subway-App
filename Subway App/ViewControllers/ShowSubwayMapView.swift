//
//  ShowSubwayMap.swift
//  Subway App
//
//  Created by Lucas on 28.12.22.
//

import Foundation
import UIKit
import MapKit


class ShowSubwayMapView: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var correntLine: Int = 0
    
    static var latitudeVienna: Double = 48.2083
    static var longitudeVienna: Double = 16.3731
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //test
        mapView.mapType = MKMapType.hybrid
        
        
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: CLLocationDistance(50000))
        
        var corrdinatesOfVienna = CLLocationCoordinate2D(latitude:ShowSubwayMapView.latitudeVienna, longitude: ShowSubwayMapView.longitudeVienna)
        mapView.setCenter(corrdinatesOfVienna, animated: false)
        
        drawStations()
        drawSubwayNet()
        
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
    
    
    
    func drawSubwayNet(){
        DispatchQueue.main.async {
            
            let database = DataBaseControll.instance
            let subwayLines = database.getAllSubwayLines()
            
            for subwayLine in subwayLines{
                var locations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
                
                for i in stride(from: 0, to: subwayLine.listOfcordinates.count, by: 1){
                    locations.append(CLLocationCoordinate2D(latitude: subwayLine.listOfcordinates[i].latitude, longitude: subwayLine.listOfcordinates[i].longitude))
                    
                    // print("add cordinates" + locations.description)
                }
                
                
                var polyline = MKPolyline(coordinates: locations, count: locations.count
                )
                
                
                self.correntLine = subwayLine.subwayLine
                
                self.mapView.addOverlay(polyline)
            }
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
