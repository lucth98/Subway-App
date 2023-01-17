//
//  RouteCalculator.swift
//  Subway App
//
//  Created by Lucas on 16.01.23.
//

import Foundation
class RouteCalculator{
    var database:DataBaseControll
    var lines: [SubwayLineTable]?
    var stations: [StationTabel]?
    var shortestRoute:Route?
    
    init() {
        self.database = DataBaseControll.instance
        getStations()
        
    }
    
    func calculate(start:StationTabel ,end: StationTabel)->Route?{
        var resultArray = calculation(start: start, end: end, route: Route())
        if(resultArray != nil){
            var result = getShortestRout(routes: resultArray!)
            return result
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
    
    private func calculation(start:StationTabel ,end: StationTabel, route: Route)->[Route]?{
        var result = [Route]()
        
       // result.append(route)
        var routeCopy = route
        
        if(!route.isEmpty()){
            var stations = getAllStationsInLine(line: route.newestLie!)
            
            for station in stations {
                if(station != start){
                    
                    var lines = getLinesWhithCordinates(cordinates: station.cordinates ?? CordinatesTabel(latitude: 0.0, longitude: 0.0))
                   
                    if(route.containStation(newStation: station)){
                        return nil
                    }
                    
                    if(station == end){
                        routeCopy.addStation(station: station)
                        result.append(routeCopy)
                        return result
                    }else{
                        if(lines != nil){
                            lines = removeLineFromLineArray(array: lines!, lineToDelite: route.newestLie!)
                           
                            var newRouts = [Route]()
                            for line in lines!{
                                var newRoute = routeCopy
                                newRoute.setNearestLine(line: line)
                                newRoute.addStation(station: station)
                                newRoute.addline(line: line)
                                
                                var addition = calculation(start: station, end: end, route: newRoute)
                                
                                if(addition != nil){
                                    newRouts.append(contentsOf: addition!)
                                }

                            }
                            
                            if(newRouts .count == 0){
                                return nil
                            }else{
                                result.append(contentsOf: newRouts)
                                return result
                            }
                            
                            
                            
                        }else{
                            return nil
                        }
                    }
                }
            }
            
            
            
        }else{
            
            
            routeCopy.addStation(station: start)
            var lines = getLinesWhithCordinates(cordinates: start.cordinates!)
            
            var newLines = [Route]()
            for line in lines!{
                var newRoute = routeCopy
                newRoute.setNearestLine(line: line)
                newRoute.addline(line: line)
                
                var routes = calculation(start: start, end: end, route: newRoute)
                if(routes != nil){
                    newLines.append(contentsOf: routes!)
                }
            }
            
            if(newLines.count != 0){
                result.append(contentsOf: newLines)
            }else{
                return nil
            }
            
        }
        return result
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
            }
            
            for line in lines{
                self.lines?.append(line)
            }
            self.check()
        }
        
    }
    
    func addStation(_ station: StationTabel){
        for stat in stations! {
            if(stat.name == station.name){
                return;
            }
        }
        stations?.append(station)
    }
    
    func check(){
        guard(stations != nil) else{
            return
        }
        for line in lines!{
            print("lines:")
            /*if(getStationForCordinates(cordinates: line.listOfcordinates[0]) != nil){
             print("true")
             }else{
             print("false")
             }*/
            print(line)
            
            
            
        }
    }
    
    func getLinesWhithCordinates(cordinates: CordinatesTabel)->[SubwayLineTable]?{
        guard(lines != nil) else {
            return [SubwayLineTable]()
        }
        var result = [SubwayLineTable]()
        
        for line in lines!{
            
            for lineCorr in line.listOfcordinates{
                if(lineCorr.latitude == cordinates.latitude && lineCorr.longitude == cordinates.longitude){
                    result.append(line)
                }
            }
        }
        return result
    }
    
    func removeLineFromLineArray(array: [SubwayLineTable], lineToDelite: SubwayLineTable)->[SubwayLineTable]{
        var result = array
        for i in stride(from: 0, to: result.count , by: 1){
            if(result[i] == lineToDelite){
                result.remove(at: i)
            }
        }
        return result
    }
    
    func getStationForCordinates(cordinates: CordinatesTabel)->StationTabel?{
        guard(stations != nil) else {
            return nil
        }
        for station in stations!{
            if(cordinates.latitude == station.cordinates?.latitude && cordinates.longitude == station.cordinates?.longitude){
                return station
            }
        }
        return nil
    }
    
    func getAllStationsInLine(line: SubwayLineTable)->[StationTabel]{
        var result = [StationTabel]()
        for cordinate in line.listOfcordinates{
            var newStation = getStationForCordinates(cordinates: cordinate)
            if(newStation != nil){
                result.append(newStation!)
            }
        }
        return result
    }
    
    
    
}
