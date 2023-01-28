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
    var route: Route?
   
    @IBOutlet weak var dropDownStart: UIButton!
    @IBOutlet weak var dropDownEnd: UIButton!
    
    @IBOutlet weak var calculationStackView: UIStackView!
    /* @IBOutlet weak var configStackView: UIStackView!
    
    
    func enableConfigStackView(){
        configStackView.isHidden = false
        calculationStackView.isHidden = true
        
    }
    
    func disableConfigStackView(){
        configStackView.isHidden = true
        calculationStackView.isHidden = false
    }
    
    @IBAction func newRoute(){
        route = nil
        disableConfigStackView()
    }
    
    @IBAction func showInMap(){
        guard (route != nil) else{
            return
        }
        
        self.performSegue(withIdentifier: "drawRoutes", sender: nil)
    }
    
    @IBAction func buyTicket(){
        
    }
      */

    
    @IBAction func calcButtonPressed(){
        guard(calculator != nil && selecetStart != nil && selecetEnd != nil) else{
            return
        }
        
      
        
        if(selecetStart == selecetEnd){
            self.drawAlert("Start and End are the same", "please enter valide data")
            return
        }
        
        DispatchQueue.main.async {
            var route = self.calculator?.calculate(start: self.selecetStart!, end: self.selecetEnd!)
            
            self.route = route
            
            if(route != nil){
                self.performSegue(withIdentifier: "routeControll", sender: nil)
               // self.enableConfigStackView()
                
            }else{
                self.drawAlert("No Route", "No possible rout could be found in the data set")
            }
        }
    }
    
    func drawAlert(_ titleOfAlert:String,_ messageOfAlert:String){
        let alert:UIAlertController=UIAlertController(title: titleOfAlert,
                                                      message: messageOfAlert,
                                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calculate Route"
        
        
        getStations()
        
        calculator = RouteCalculator()
        
      //  disableConfigStackView()
      
    }
    
    
    func getStations(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            self.stations = database.getStationsAsArray()
            self.fillDropDownMenues()
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
    
    func sortStations(){
        guard (stations != nil) else{
            return
        }
        var database = DataBaseControll.instance
        stations = database.sortStationArray(arrayOfStations: stations!)
    }
    
    
    func fillDropDownMenues(){
        guard (stations != nil) else{
            return
        }
        
        let clouseStartMenue = {(action: UIAction) in
            self.startStationSelecet(name: action.title)
        }
        
        let clouseEndMenue = {(action: UIAction) in
            self.endStationSelecet(name: action.title)
        }
        
        var startMenueElemts = [UIMenuElement]()
        var endMenueElemts = [UIMenuElement]()
        
        sortStations()
        
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
    //    print(selecetStart)
        
    }
    
    func endStationSelecet(name: String){
        dropDownEnd.setTitle(name, for: .normal)
        selecetEnd = getStation(name)
     //   print(selecetEnd)
    }
    
    func addStationToList(_ newStation: StationTabel){
        for stationName in stations! {
            if(stationName.name == newStation.name){
                return;
            }
        }
        stations?.append(newStation)
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        guard let routeControllViewController = segue.destination as? RouteControllView
        else{
            return
        }
        
        if(route != nil){
            routeControllViewController.route = self.route!
            
        }
    }
}
