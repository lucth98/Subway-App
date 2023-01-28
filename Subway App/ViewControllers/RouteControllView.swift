//
//  RouteControllView.swift
//  Subway App
//
//  Created by Lucas on 28.01.23.
//

import Foundation
import UIKit

class RouteControllView: ViewController, UITableViewDelegate ,UITableViewDataSource {
    var route:Route?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Route"
        
        
        tableView.delegate = self
        tableView.dataSource = self
       
        
        tableView.reloadData()
        print(route)
    }
    
    @IBAction func showRoute(){
       
            guard(self.route != nil)else{
                return
            }
            
            self.performSegue(withIdentifier: "drawRoute", sender: nil)
        
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        guard let routeViewController = segue.destination as? RouteView
        else{
            return
        }
        
        if(route != nil){
            routeViewController.route = self.route!
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count")
        guard(route != nil) else{
            
            
            return 0
        }
        print(route?.lineNumbers.count.description)
        return (route?.lineNumbers.count)!
    }
    
    
    private func getDescription(index:Int)->String{
     
        var result = "Line: U"
        
        result += route?.lineNumbers[index].description ?? " DATA ERROR"
        result += " "
        
        var firstStation: AdvancedStation = AdvancedStation()
        var lastStation: AdvancedStation = AdvancedStation()
        
        for station in (route?.stations)!{
            for line in station.subwayLines{
                if(line == route?.lineNumbers[index]){
                    firstStation = station
                    break
                }
            }
        }
        
        for station in (route?.stations)!{
            for line in station.subwayLines{
                if(line == route?.lineNumbers[index]){
                    lastStation = station
                    
                }
            }
        }
        
        result += firstStation.name
        result += " -> "
        result += lastStation.name
    
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("fill")
        guard(route != nil) else{
            print("nil")
            return UITableViewCell()
        }
        
        
        var index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeInfoCell") as! LineInfoCell
         var text = getDescription(index: index)
        print(text)
        cell.setText(text: text)
        
        return cell
    }
}
