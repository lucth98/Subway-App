//
//  DisplayData.swift
//  Subway App
//
//  Created by Lucas on 28.12.22.
//

import Foundation
import UIKit


class DisplayDataView: UIViewController, UITableViewDelegate ,UITableViewDataSource {
    var stationList: [StationTabel]?
    var subwayLines: [SubwayLineTable]?
    var stationNames: [String]?
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard(stationNames != nil) else{
            return 0
        }
        
        guard(subwayLines != nil)else{
            return 0
        }
        
        return stationNames!.count + subwayLines!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard(stationNames != nil) else{
            return UITableViewCell()
        }
        guard(subwayLines != nil) else{
            return UITableViewCell()
        }
        
        var index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell") as! SationTableViewCell
        
        print()
        print()
        print("index:" + index.description)
        print("anz station:" + (stationNames?.count.description)!)
        print()
        print("anz lines:" + (subwayLines?.count.description)!)
        
        if(!(index > stationNames!.count-1)){
         
            cell.setName(stationNames![index])
        }else{
           
            print(index)
            var line = subwayLines![index-stationNames!.count].subwayLine
            cell.setName("Line: " + String(line))
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getStationsAndLines()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getStationsAndLines()
        
    }
    
    func getStationsAndLines(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            let stations = database.getAllStations()
            let lines = database.getAllSubwayLines()
            
            self.stationList = [StationTabel]()
            self.subwayLines = [SubwayLineTable]()
            self.stationNames = [String]()
            
            for station in stations{
                self.stationList?.append(station)
                // print(station)
                
                self.addNameToList("Station: "+station.name)
            }
            
            for line in lines{
                self.subwayLines?.append(line)
            }
            
            
           // for station in St
            
            // print(self.stationList)
            self.tableView.reloadData()
        }
       
    }
    
    func addNameToList(_ name: String){
        for stationName in stationNames! {
            if(stationName == name){
                return;
            }
        }
        stationNames?.append(name)
    }
    
}
