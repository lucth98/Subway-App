//
//  TrainCell.swift
//  Subway App
//
//  Created by Lucas on 31.01.23.
//


import Foundation
import UIKit

class TrainCell: UITableViewCell{
    
    

    @IBOutlet weak var infoLabel: UILabel!
    
    func setText(text:String){
        infoLabel.text = text
    }
}
