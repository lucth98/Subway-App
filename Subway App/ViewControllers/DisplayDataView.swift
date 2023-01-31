//
//  DisplayData.swift
//  Subway App
//
//  Created by Lucas on 28.12.22.
//

import Foundation
import UIKit


class DisplayDataView: UIViewController, UITableViewDelegate ,UITableViewDataSource {
    private var stationList: [AdvancedStation] = []
    private var subwayLines: [AdvancedLine] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard(stationList.count != 0 && subwayLines.count != 0) else{
            return 0
        }
        
        return stationList.count + subwayLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard(stationList.count != 0 && subwayLines.count != 0) else{
            return UITableViewCell()
        }
        
        var index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell") as! SationTableViewCell
        
        if(!(index > stationList.count-1)){
            cell.setName("Station: " + stationList[index].name)
        }else{
      
            var line = subwayLines[index-stationList.count].subwayLine
            cell.setName("Line: " + String(line))
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Display Data"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getStationsAndLines()
    }
    
    func getStationsAndLines(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            var tableStations = database.getStationsAsArray()
            tableStations =  database.sortStationArray(arrayOfStations: tableStations)
            for station in tableStations {
                self.stationList.append(AdvancedStation.convert(station: station))
            }
             var tableSubwayLines = database.getLinesAsArray()
            
            tableSubwayLines = database.sortSubwayLinesArray(arrayOfLines: tableSubwayLines)
            
            
            for line in tableSubwayLines {
                self.subwayLines.append(AdvancedLine.convert(line: line))
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        guard let displayCorrdinatesView = segue.destination as? DisplayCorrdinatesView, let index = tableView.indexPathForSelectedRow?.row
        else{
            return
        }
        guard(stationList.count != 0) else{
            return
        }
        guard(subwayLines.count != 0) else{
            return
        }
        
        var corrArray:[SimpleCordinates] = [SimpleCordinates]()
        
        if(!(index > stationList.count-1)){
            
            corrArray.append( stationList[index].cordinates!)
        }else{
            corrArray.append(contentsOf: subwayLines[index-stationList.count].listOfcordinates)
        }
        
        displayCorrdinatesView.cordinates = corrArray
    }
    
    
    
    
}
