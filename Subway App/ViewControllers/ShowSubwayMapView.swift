//
//  ShowSubwayMap.swift
//  Subway App
//
//  Created by Lucas on 28.12.22.
//

import Foundation
import UIKit
import MapKit

class ShowSubwayMapView: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //test
        mapView.mapType = MKMapType.hybrid
        
        
    }


}
