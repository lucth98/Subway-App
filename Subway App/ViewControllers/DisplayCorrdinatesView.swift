//
//  DisplayCorrdinatesView.swift
//  Subway App
//
//  Created by Lucas on 19.01.23.
//

import Foundation
import UIKit

class DisplayCorrdinatesView: ViewController , UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cordinates: [CordinatesTabel]?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard(cordinates != nil) else{
            return 0
        }
     
        return cordinates!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard(cordinates != nil) else{
            return UITableViewCell()
        }
       
        
        var index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "corrCell") as! corrdinatesTableViewCell
        
        cell.setLeabelTex(longitude: cordinates![index].longitude, latidude: cordinates![index].latitude)
        
        return cell
    }
    
}
