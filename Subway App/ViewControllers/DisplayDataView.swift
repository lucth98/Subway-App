//
//  DisplayData.swift
//  Subway App
//
//  Created by Lucas on 28.12.22.
//

import Foundation
import UIKit


class DisplayDataView: UIViewController, UITableViewDelegate ,UITableViewDataSource {
    private var stationList: [StationTabel]?
    private var subwayLines: [SubwayLineTable]?
    private var corrArray: [CordinatesTabel]?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard(stationList != nil && subwayLines != nil) else{
            return 0
        }
        
        return stationList!.count + subwayLines!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard(stationList != nil && subwayLines != nil) else{
            return UITableViewCell()
        }
       
        
        var index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell") as! SationTableViewCell
        
        if(!(index > stationList!.count-1)){
            
            cell.setName("Station: " + stationList![index].name)
        }else{
            
            print(index)
            var line = subwayLines![index-stationList!.count].subwayLine
            cell.setName("Line: " + String(line))
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Display Data"
        
       // getStationsAndLines()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getStationsAndLines()
    }
    
    
    
    func getStationsAndLines(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            self.stationList = database.getStationsAsArray()
            self.subwayLines = database.getLinesAsArray()
          
            self.stationList = database.sortStationArray(arrayOfStations: self.stationList!)
            self.subwayLines = database.sortSubwayLinesArray(arrayOfLines: self.subwayLines!)
            
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        guard let displayCorrdinatesView = segue.destination as? DisplayCorrdinatesView, let index = tableView.indexPathForSelectedRow?.row
        else{
            return
        }
        guard(stationList != nil) else{
            return
        }
        guard(subwayLines != nil) else{
            return
        }
       
        var corrArray:[CordinatesTabel] = [CordinatesTabel]()
        
        if(!(index > stationList!.count-1)){
            
            corrArray.append( stationList![index].cordinates!)
        }else{
            corrArray.append(contentsOf: subwayLines![index-stationList!.count].listOfcordinates)
        }
        
        displayCorrdinatesView.cordinates = corrArray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getStationsAndLines()
       
    }
    

}
