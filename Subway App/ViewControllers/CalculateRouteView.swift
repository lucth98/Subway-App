//
//  CalculateRoute.swift
//  Subway App
//
//  Created by Lucas on 28.12.22.
//

import Foundation
import UIKit

class CalculateRouteView: UIViewController {

    var stations: [StationTabel]?
    
    var selecetStart: StationTabel?
    var selecetEnd: StationTabel?
    
    var calculator: RouteCalculator?
    
    
    @IBOutlet weak var dropDownStart: UIButton!
    @IBOutlet weak var dropDownEnd: UIButton!
    
    @IBAction func calcButtonPressed(){
        guard(calculator != nil) else{
            return
        }
        
        guard(selecetStart != nil) else{
            return
        }
        
        guard(selecetEnd != nil) else{
            return
        }
        
        var route = calculator?.calculate(start: selecetStart!, end: selecetEnd!)
        print(route)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //testdrop()
        
        getStations()
        
       calculator = RouteCalculator()
        
    }
    
    
    func getStations(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            let stations = database.getAllStations()
            
            self.stations = [StationTabel]()
            
            for station in stations{
                self.addStationToList(station)
              //  self.stations?.append(station)
              // print(station)
            }
            self.fillDropDownMenues()
           // print(self.stationList)
        }
    }
    
    func getStation(_ name: String)->StationTabel?{
        guard(stations != nil)else{
            return nil
        }
        for station in stations!{
            if(station.name == name){
                return station
            }
        }
        return nil
    }
    
    
    func fillDropDownMenues(){
        guard (stations != nil) else{
            return
        }
        
        let clouseStartMenue = {(action: UIAction) in
            self.startStationSelecet(name: action.title)
        //  self.update(number: action.title)
        }
        
        let clouseEndMenue = {(action: UIAction) in
            self.endStationSelecet(name: action.title)
          //  self.update(number: action.title)
        }
        
        var startMenueElemts = [UIMenuElement]()
        var endMenueElemts = [UIMenuElement]()
        
        for station in stations!{
            var elementStart = UIAction(title: station.name, state: .off, handler:
                                            clouseStartMenue)
            var elmentEnd = UIAction(title:station.name, state: .off, handler:
                                        clouseEndMenue)
            
            startMenueElemts.append(elementStart)
            endMenueElemts.append(elmentEnd)
        }
        
        dropDownStart.menu = UIMenu(title: "select start station",children: startMenueElemts)
        dropDownEnd.menu = UIMenu(title: "select end Station", children: endMenueElemts)
    }
    
    func startStationSelecet(name: String){
        dropDownStart.setTitle(name, for: .normal)
        selecetStart = getStation(name)
        print(selecetStart)
        
    }
    
    func endStationSelecet(name: String){
        dropDownEnd.setTitle(name, for: .normal)
        selecetEnd = getStation(name)
        print(selecetEnd)
    }
    
    func addStationToList(_ newStation: StationTabel){
        for stationName in stations! {
            if(stationName.name == newStation.name){
                return;
            }
        }
        stations?.append(newStation)
    }
}
