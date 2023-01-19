//
//  corrdinatesTableViewCell.swift
//  Subway App
//
//  Created by Lucas on 19.01.23.
//

import Foundation
import UIKit

class corrdinatesTableViewCell:UITableViewCell{
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    func setLeabelTex(longitude:Double,latidude: Double){
        longitudeLabel.text = "Long: " + longitude.description
        latitudeLabel.text = "Lat: " + latidude.description
    }
}
