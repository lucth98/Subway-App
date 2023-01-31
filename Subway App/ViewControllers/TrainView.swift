//
//  TrainView.swift
//  Subway App
//
//  Created by Lucas on 29.01.23.
//

import Foundation
import UIKit

class TrainView: ViewController, UITableViewDelegate ,UITableViewDataSource {
    var station:AdvancedStation?
    var line = 0
    var trainAPI = TrainAPI()
    var diva = 0
  
    var trainName:[String] = []
    
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trains"
        
        tabelView.delegate = self
        tabelView.dataSource = self
        
        if let stat = station {
            stationLabel.text = stat.name
        }
        lineLabel.text = "U" + line.description
        
        var fileReader = FileReader()
        fileReader.read()
        
        print("diva:")
        diva = fileReader.getDiva(stationName: station!.name)
        
        if(diva != -1){
            
            
            trainAPI.getTrains(diva: diva ){
                data, error in
                
                
                
                
                if(error != nil){
                    print(error)
                }
                
                if(data != nil){
                    print(data)
                    print("data recived")
                    self.fillTrainName(trainData: data!)
                    self.tabelView.reloadData()
                } else{
                    print("error")
                    print(data)
                }
                //    print(error)
                
            }
        }else{
            
        }
        
    }
    
    func fillTrainName(trainData: TrainData){
        for lines in trainData.data.monitors{
            for line in lines.lines{
                var name = line.name
                var target = line.towards
                
                for times in line.departures.departure{
                    var time = times.departureTime.timePlanned
                    
                    var newOutPutLine:String = name + " " + target + " " + time
                    print("String: "+newOutPutLine)
                    self.trainName.append(newOutPutLine)
                }
            }
                    
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard(trainName != nil) else{
            return 0
        }
        print()
        print("tabel rows")
        print(trainName.count)
        return trainName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard(trainName != nil) else{
            return UITableViewCell()
        }
        
        
        var index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainCell") as! TrainCell
        var text:String = self.trainName[index]
        cell.setText(text:text )
        
        return cell
    }
}





