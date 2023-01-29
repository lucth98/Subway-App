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
    var textOutPut: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Route"
        
        tableView.delegate = self
        tableView.dataSource = self
       
        generateTextOutPut()
        
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
        guard(route != nil) else{
            return 0
        }
        return ((route?.lineNumbers.count) ?? 0)*2
    }
    
    private func generateTextOutPut(){
        textOutPut = []
        
        for line in (route?.lineNumbers)!{
            
            let firstStation = getFirstStaionInLine(lineOfStation: line)
            let lastStation = getLastStaionInLine(lineOfStation: line)
            
            var firstString = "U" + line.description + " From: " + (firstStation?.name ?? "Error: no name")
            var secondString = "U" + line.description + " To: " + (lastStation?.name ?? "Error: no name")
            textOutPut.append(firstString)
            textOutPut.append(secondString)
        }
    }
    
    private func getFirstStaionInLine( lineOfStation:Int)->AdvancedStation?{
        for station in (route?.stations)!{
            for line in station.subwayLines{
                if(line == lineOfStation){
                    return station
                }
            }
        }
        return nil
    }
    
    private func getLastStaionInLine( lineOfStation:Int)->AdvancedStation?{
        var result: AdvancedStation? = nil
        
        for station in (route?.stations)!{
            for line in station.subwayLines{
                if(line == lineOfStation){
                   result = station
                }
            }
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard(route != nil) else{
            return UITableViewCell()
        }
        
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeInfoCell") as! LineInfoCell
        var text = textOutPut[index]
      
        cell.setText(text: text)
        
        return cell
    }
}
