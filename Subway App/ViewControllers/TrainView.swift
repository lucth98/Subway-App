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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var titleText:String = "Trains " + "U" + line.description + " " + (station?.name ?? "no name")
        title = titleText
        
        tabelView.delegate = self
        tabelView.dataSource = self

        
        var fileReader = FileReader()
        fileReader.read()
        
        //print("diva:")
        diva = fileReader.getDiva(stationName: station!.name)
        
        if(diva != -1){
            trainAPI.getTrains(diva: diva ){
                data, error in
                
                if(error != nil){
                    print(error)
                }
                
                if(data != nil){
                    
                    //print(data)
                    //print("data recived")
                    self.fillTrainName(trainData: data!)
                    self.tabelView.reloadData()
                } else{
                   // print("error")
                  //  print(data)
                }
            }
        }
    }
    
    func fillTrainName(trainData: TrainData){
        var trainLine = "U" + line.description
        
        let dateFormatter = DateFormatter.iso8601Full
       
        let outputFormater = DateFormatter()
        outputFormater.dateFormat = "HH:mm"
        
        for lines in trainData.data.monitors{
            for line in lines.lines{
                var name = line.name
                var target = line.towards
                
                for times in line.departures.departure{
                    var time = times.departureTime.timePlanned
                  
                    
                    var newOutPutLine:String =  ""
                    if let formatetTime = dateFormatter.date(from: time){
                        
                        
                        newOutPutLine = target + " " + ( outputFormater.string(from: formatetTime))
                    }else{
                       
                        newOutPutLine = target + " " + ( time.description)
                    }
                    
                    
                    if(name == trainLine){
                        self.trainName.append(newOutPutLine)
                    }
                }
            }
                    
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard(trainName.count != 0) else{
            return 1
        }
       
        return trainName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard(trainName.count != 0) else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "trainCell") as! TrainCell
            cell.setText(text:"no Trains currently" )
            
            return cell
        }
        var index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainCell") as! TrainCell
        cell.setText(text:self.trainName[index] )
        
        return cell
    }
}



extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
