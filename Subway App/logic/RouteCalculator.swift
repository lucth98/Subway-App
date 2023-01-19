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
            /*
            print("")
            print("")
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            print("stations in line =" + lineNumber.description)
            print(stationInLine)
            print("")
            print("anz of stations")
            print(stationInLine.count)
            print("???????????????????????????")*/
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
                        routeCopy.addLineNumber(line: lineNumber)
                        routeCopy.addStation(station: station)
                        
                        result.append(routeCopy)
                        return result
                    }
                    
                    var routeNew = routeCopy
                    routeNew.addLineNumber(line: lineNumber)
                    //todo station zwischen start und station hinzufügen
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
    
    func getAllStationBetween(start:StationTabel, end: StationTabel, array:[StationTabel]){
        
        
    }
    
    func getDistanzbetweenToStations(start:StationTabel, end: StationTabel) -> CLLocationDistance{
        var position1 = CLLocation(latitude: start.cordinates!.latitude, longitude: start.cordinates!.longitude)
        var position2 = CLLocation(latitude: end.cordinates!.latitude, longitude: start.cordinates!.longitude)

        return position1.distance(from: position2)
    }
    
    func getNearstStation(longitude: Double, latitude: Double, stationArray:[StationTabel]) -> [StationTabel]?{
        
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
                    
                    var previosLocation = CLLocation(latitude: savedStation.cordinates!.latitude , longitude: savedStation.cordinates!.longitude )
                    var currenLocation = CLLocation(latitude: station.cordinates!.latitude , longitude: station.cordinates!.longitude )
                    
                    previosDistance = positionLastStation.distance(from: previosLocation)
                    
                    var curentDistanze = positionLastStation.distance(from: currenLocation)
                    
                    if(curentDistanze < previosDistance){
                        
                        result[0] = station
                        result[1] = savedStation
                        
                        savedStation = station
                        savedStation
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
    
    private func calculation(start:StationTabel ,end: StationTabel, route: Route)->[Route]?{
        var result = [Route]()
        
        
        var routeCopy = route
        
        if(!route.isEmpty()){
            // print("bäbä")
            var stationsInLine = getAllStationsInLine(line: routeCopy.newestLie!)
            
            /*
             print("")
             print("")
             print("line = ")
             print(routeCopy.newestLie)
             print("stationen= ")
             print(stationsInLine.count)
             */
            
            for station in stationsInLine {
                if(station != start){
                    
                    var lines = getLinesWhithCordinates(cordinates: station.cordinates!)
                    
                    print("lines cor")
                    print(lines?.count)
                    
                    if(routeCopy.containStation(newStation: station)){
                        return nil
                    }
                    
                    if(station == end){
                        
                        routeCopy.addStation(station: station)
                        result.append(routeCopy)
                        return result
                    }else{
                        if(lines != nil && lines?.count != 0){
                            lines = removeLineFromLineArray(array: lines!, lineToDelite: routeCopy.newestLie!)
                            
                            var newRouts = [Route]()
                            for line in lines!{
                                if(line == routeCopy.newestLie){
                                    continue
                                }
                                
                                var newRoute = routeCopy
                                newRoute.setNearestLine(line: line)
                                newRoute.addStation(station: station)
                                newRoute.addline(line: line)
                                
                                var addition = calculation(start: station, end: end, route: newRoute)
                                
                                if(addition != nil && addition?.count != 0){
                                    newRouts.append(contentsOf: addition!)
                                }
                                
                            }
                            if(newRouts.count != 0){
                                
                                result.append(contentsOf: newRouts)
                                return result
                            }else{
                                return nil
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
            
            print(lines)
            var newLines = [Route]()
            /*
             print("bä")
             
             print("lines:")
             print(lines)
             print("corr:")
             print(start.cordinates!)
             */
            
            
            for line in lines!{
                
                var newRoute = routeCopy
                newRoute.setNearestLine(line: line)
                newRoute.addline(line: line)
                
                var routes = calculation(start: start, end: end, route: newRoute)
                if(routes != nil){
                    newLines.append(contentsOf: routes!)
                }
            }
            result.append(contentsOf: newLines)
            
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
                //self.stations?.append(station)
            }
            
            for line in lines{
                self.lines?.append(line)
            }
            self.check()
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
    
    func check(){
        guard(stations != nil) else{
            return
        }
        for line in lines!{
            //  print("lines:")
            /*if(getStationForCordinates(cordinates: line.listOfcordinates[0]) != nil){
             print("true")
             }else{
             print("false")
             }*/
            //  print(line)
            
            
            
        }
    }
    
    func getLinesWhithCordinates(cordinates: CordinatesTabel)->[SubwayLineTable]?{
        guard(lines != nil) else {
            
            return nil
        }
        var result = [SubwayLineTable]()
        
        for line in lines!{
            
            for lineCorr in line.listOfcordinates{
                
                /*
                 print("")
                 print("cordinates seacrched="+cordinates.latitude.debugDescription+" "+cordinates.longitude.debugDescription)
                 print("cordinates reacced  ="+lineCorr.latitude.debugDescription+" "+lineCorr.longitude.debugDescription)
                 */
                if(areCordinatesEqual(firstCordinates: cordinates, secondCordinates: lineCorr)){
                    /*
                     print(" ")
                     print("cordinates")
                     print(cordinates.latitude.debugDescription+" "+cordinates.longitude.debugDescription)
                     print("line corr")
                     print(lineCorr.latitude.debugDescription+" "+lineCorr.longitude.debugDescription)
                     */
                    result.append(line)
                }
                /*
                 if(lineCorr.latitude == cordinates.latitude && lineCorr.longitude == cordinates.longitude){
                 result.append(line)
                 }*/
            }
        }
        return result
    }
    
    
    func roundAt( input:Double)->Double{
        var comma = 1000000000000.0
        return round(comma * input) / comma
    }
    
    func convertToInt(input:Double)->Int{
        var comma = 1000000000000.0
        return Int(input*comma)
    }
    
    
    func areCordinatesEqual(firstCordinates: CordinatesTabel, secondCordinates: CordinatesTabel)->Bool{
        var longDiffernz = convertToInt(input: firstCordinates.longitude)  - convertToInt(input: secondCordinates.longitude)
        var latDiffernz = convertToInt(input: firstCordinates.latitude)  - convertToInt(input: secondCordinates.latitude)
        
        
        
        longDiffernz = makePositive(input: longDiffernz)
        latDiffernz = makePositive(input: latDiffernz)
        var comperator =  100000
        // print(doublelat)
        //print(doublelong)
        if(longDiffernz == 0 && latDiffernz  == 0){
            /*
             print("")
             print("first")
             print(firstCordinates)
             print("second")
             print(secondCordinates)
             
             print(longDiffernz)
             print(latDiffernz)
             print(latDiffernz == 0)
             print(latDiffernz == 0)
             */
            return true
        }
        return false
        
        
        
        
        
    }
    
    func makePositive(input:Int )->Int{
        if(input < 0){
            return input * -1
        }
        return input
    }
    
    func removeLineFromLineArray(array: [SubwayLineTable], lineToDelite: SubwayLineTable)->[SubwayLineTable]{
        var result = array
        for i in stride(from: 0, to: result.count , by: 1){
            if(result[i] == lineToDelite){
                result.remove(at: i)
                return result
            }
        }
        return result
    }
    
    func getStationForCordinates(cordinates: CordinatesTabel)->StationTabel?{
        guard(stations != nil) else {
            return nil
        }
        for station in stations!{
            
            if(areCordinatesEqual(firstCordinates: cordinates, secondCordinates: (station.cordinates)!)){
                /*
                 print("   ")
                 print("station cor")
                 print((station.cordinates?.latitude.debugDescription)!+" "+(station.cordinates?.longitude.debugDescription)!
                 )
                 print("corr")
                 print(cordinates.latitude.debugDescription+" "+cordinates.longitude.debugDescription)
                 */
                return station
            }
            /*
             if(cordinates.latitude == station.cordinates?.latitude && cordinates.longitude == station.cordinates?.longitude){
             return station
             }
             */
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
