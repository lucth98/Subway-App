//
//  LineInfoCell.swift
//  Subway App
//
//  Created by Lucas on 28.01.23.
//

import Foundation
import UIKit

class LineInfoCell: UITableViewCell{
    
    

    @IBOutlet weak var infoLabel: UILabel!
    
    func setText(text:String){
        infoLabel.text = text
    }
}
