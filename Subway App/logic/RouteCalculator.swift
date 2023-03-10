//
//  RouteCalculator.swift
//  Subway App
//
//  Created by Lucas on 16.01.23.
//

import Foundation
import MapKit

class RouteCalculator{
    var database:DataBaseControll
    var lines: [SubwayLineTable]?
    var stations: [StationTabel]?
    var shortestRoute:Route?
    
    init() {
        self.database = DataBaseControll.instance
        getStations()
        
    }
    
    private func calculation2(start:StationTabel ,end: StationTabel, route: Route)->[Route]?{
        var routeCopy = route
        var result = [Route]()
        
       
        
        var linesOfStartStation = getallLinesForThisStation(station: start)
        routeCopy.addStation(station: start)
        
        print("lines of start:")
        print(linesOfStartStation)
        print("start Station")
        print(start)
        
        
        var newRoutes = [Route]()
        
        for lineNumber in linesOfStartStation{
            if(routeCopy.hasThisLine(line: lineNumber)){
                continue
            }
            
            
            var stationInLine = getAllStationInThisLine(lineNumber: lineNumber)
       
            for station in stationInLine {
                /*
                print("")
                print("name sttion = " + station.name + " ende name= " + end.name)
                print(station.name == end.name)
                */
                
                if(!(station.name == start.name)){
                    
                    if(station.name == end.name){
                        print("targed reaced")
                        // ziel ereicht return
                        
                        //todo station zwischen start und station hinzufügen
                        
                        /*
                        var stationsBetween = getAllStationBetween(start: start, end: station, array: stationInLine)
                        for between in stationsBetween {
                            routeCopy.addStation(station: between)
                        }
                        */
                        
                        routeCopy.addLineNumber(line: lineNumber)
                        routeCopy.addStation(station: station)
                        
                        result.append(routeCopy)
                        return result
                    }
                    
                    var routeNew = routeCopy
                    routeNew.addLineNumber(line: lineNumber)
                    //todo station zwischen start und station hinzufügen
                    
                    /*
                    var stationsBetween = getAllStationBetween(start: start, end: station, array: stationInLine)
                    for between in stationsBetween {
                        routeCopy.addStation(station: between)
                    }
                    */
                    routeNew.addStation(station: station)
                    
                    var next = calculation2(start: station, end: end, route: routeNew)
                    
                    if(next != nil && next?.count != 0){
                        newRoutes.append(contentsOf: next!)
                    }
                }
            }
        }
        
        if (newRoutes.count != 0 ){
            result.append(contentsOf: newRoutes)
        }
        
        return result
        
    }
    
    func getAllStationBetween(start:StationTabel, end: StationTabel, array:[StationTabel])->[StationTabel]{
        var result = [StationTabel]()
        var currentStation = start
        
        guard(stationIncludetInArray(station: start, array: array)) else{
            return result
        }
        guard(stationIncludetInArray(station: end, array: array)) else{
            return result
        }
        print("start =" + start.name + " ende=" + end.name)
        while(currentStation.name != end.name){
            var nearestStation = getNearstStation(longitude: currentStation.cordinates!.longitude, latitude: currentStation.cordinates!.longitude, stationArray: array,currentStation: currentStation)
            
            if(nearestStation != nil){
                print("not null")
                if(getDistanzbetweenToStations(start: nearestStation![0], end: end) < getDistanzbetweenToStations(start: nearestStation![1], end: end)){
                    print("neast station= " + currentStation.name + " " + nearestStation![0].name + " " + nearestStation![1].name)

                    currentStation = nearestStation![0]
                    result.append(nearestStation![0])
                    print("nahe")
                }else{
                    print("neast station= " + currentStation.name + " " + nearestStation![0].name + " " + nearestStation![1].name)

                    currentStation = nearestStation![1]
                    result.append(nearestStation![1])
                    print("fern")
                }
            }
          
        }
        return result
    }
    
    func stationIncludetInArray(station: StationTabel, array: [StationTabel]) -> Bool{
        for stat in array{
            if(stat == station){
                return true
            }
        }
        return false
    }
    
    func getDistanzbetweenToStations(start:StationTabel, end: StationTabel) -> CLLocationDistance{
        var position1 = CLLocation(latitude: start.cordinates!.latitude, longitude: start.cordinates!.longitude)
        var position2 = CLLocation(latitude: end.cordinates!.latitude, longitude: start.cordinates!.longitude)

        return position1.distance(from: position2)
    }
    
    func getNearstStation(longitude: Double, latitude: Double, stationArray:[StationTabel], currentStation: StationTabel) -> [StationTabel]?{
        
        var result = [StationTabel]()
        var positionLastStation = CLLocation(latitude: latitude, longitude: longitude)
        
        
        if(stations != nil ){
            if(stations!.count > 0){
                
                var firstStation = CLLocation(latitude: (stationArray[0].cordinates?.latitude)! , longitude: (stationArray[0].cordinates?.longitude)! )
                
                var savedStation: StationTabel = stationArray[0]
                var previosDistance: Double
                
                result.append(savedStation)
                result.append(savedStation)
                
                for station in stationArray{
                    if(currentStation == station){
                        continue
                    }
                    var previosLocation = CLLocation(latitude: savedStation.cordinates!.latitude , longitude: savedStation.cordinates!.longitude )
                    var currenLocation = CLLocation(latitude: station.cordinates!.latitude , longitude: station.cordinates!.longitude )
                    
                    previosDistance = positionLastStation.distance(from: previosLocation)
                    
                    var curentDistanze = positionLastStation.distance(from: currenLocation)
                    
                    if(curentDistanze < previosDistance){
                        
                        result[0] = station
                        result[1] = savedStation
                        
                        savedStation = station
                        
                    }
                }
                
                return result
            }
        }
        return nil
    }
    
    func getallLinesForThisStation(station: StationTabel)->[Int]{
        guard(stations != nil) else{
            return [Int]()
        }
        var result = [Int]()
        
        
        for stat in stations!{
            if(stat.name == station.name){
                if(!isAllreadyAdded(input: result, value: stat.subwayLine)){
                    result.append(stat.subwayLine)
                }
                
            }
            
        }
        return result
    }
    
    func isAllreadyAdded(input: [Int], value: Int)->Bool{
        for i in input{
            if(i == value){
                return true
            }
        }
        return false
    }
    
    func getAllStationInThisLine(lineNumber:Int)->[StationTabel]{
        guard(stations != nil) else{
            return [StationTabel]()
        }
        var result = [StationTabel]()
        for station in stations!{
            if(station.subwayLine == lineNumber){
                result.append(station)
            }
        }
        return result
    }
    
    func calculate(start:StationTabel ,end: StationTabel)->Route?{
        var resultArray = calculation2(start: start, end: end, route: Route())
       /* print()
        print("result:")
        print(resultArray)
        return nil*/
        
         if(resultArray != nil){
         if(resultArray?.count != 0){
         var result = getShortestRout(routes: resultArray!)
         return result
         }
         else {
         return nil
         }
         }else{
         return nil
         }
         
    }
    
    private func getShortestRout(routes: [Route])->Route{
        var shortest = routes[0]
        
        for route in routes {
            if(route.getLength() < shortest.getLength()){
                shortest = route
            }
        }
        return shortest
    }
    
   
    
    func getStations(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            let newstations = database.getAllStations()
            let lines = database.getAllSubwayLines()
            
            self.stations = [StationTabel]()
            self.lines = [SubwayLineTable]()
            
            for station in newstations{
                 self.addStation(station)
                //self.stations?.append(station)
            }
            
            for line in lines{
                self.lines?.append(line)
            }
            
        }
        
    }
    
    func addStation(_ station: StationTabel){
        for stat in stations! {
            if(stat == station){
                return;
            }
        }
        stations?.append(station)
    }
    
    
    
    func getLinesForStation(station: StationTabel)->[Int]{
        
    }
}
