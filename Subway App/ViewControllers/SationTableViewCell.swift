//
//  SationTableViewCell.swift
//  Subway App
//
//  Created by Lucas on 13.01.23.
//

import Foundation
import UIKit


class SationTableViewCell: UITableViewCell{
    
    @IBOutlet weak var stationNameLabel: UILabel!
    
    
    func setName(_ name:String){
        stationNameLabel.text = name
    }
}
