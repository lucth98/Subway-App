//
//  RouteCalculator.swift
//  Subway App
//
//  Created by Lucas on 16.01.23.
//

import Foundation
import MapKit

class RouteCalculator{
    public static var allowedDistantceBetweenCorrdinates = 100000000
    
    private    var database:DataBaseControll
    private    var lines: [SubwayLineTable]?
    private    var stations: [AdvancedStation] = []
    
    
    init() {
        self.database = DataBaseControll.instance
        getStations()
    }
    
    private func calculation(start:AdvancedStation ,end: AdvancedStation, route: Route)->[Route]?{
        var routeCopy = route
        var result = [Route]()
        
        if(routeCopy.isEmpty()){
          
            routeCopy.addStation(station: start)
        }
        var linesOfStartStation = start.subwayLines // getallLinesForThisStation(station: start)
        
        /*
        print("lines of start:")
        print(linesOfStartStation)
        print("start Station")
        print(start)
        
         */
        var newRoutes = [Route]()
        
        for lineNumber in linesOfStartStation{
            if(routeCopy.hasThisLine(line: lineNumber)){
                continue
            }
            
            var stationInLine = getAllStationInThisLine(lineNumber: lineNumber)
            
           // stationInLine = AdvancedStation.removeMultipleStaionsFromStationArray(stations: routeCopy.stations, array: stationInLine)
            
            for station in stationInLine {
                
                /*
                print("")
                print("name sttion = " + station.name + " ende name= " + end.name)
                print(station.name == end.name)
                */
                
                if((station.name != start.name)){
                    
                    if(station.name == end.name){
                       // print("targed reaced")
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
                     }*/
                    
                    routeNew.addStation(station: station)
                    
                    var next = calculation(start: station, end: end, route: routeNew)
                    
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
    
    private   func getAllStationBetween(start:AdvancedStation, end: AdvancedStation, array:[AdvancedStation])->[AdvancedStation]{
        var result = [AdvancedStation]()
        var currentStation = start
        var arrayCopy = array
        
        guard(stationIncludetInArray(station: start, array: array)) else{
            return result
        }
        guard(stationIncludetInArray(station: end, array: array)) else{
            return result
        }
        print()
        print()
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print()
        print("start =" + start.name + " ende=" + end.name)
        while(currentStation.name != end.name){
            print(currentStation.name)
            var nearestStation = getNearstStation( stationArray: arrayCopy,currentStation: currentStation)
            
            if(nearestStation != nil){
                
                if(getDistanzbetweenToStations(start: nearestStation![0], end: end) < getDistanzbetweenToStations(start: nearestStation![1], end: end)){
                    //   print("neast station= " + currentStation.name + " " + nearestStation![0].name + " " + nearestStation![1].name)
                    
                    currentStation = nearestStation![0]
                    result.append(nearestStation![0])
                    
                    arrayCopy = AdvancedStation.removeStaionFromStationArray(station: nearestStation![0], array: arrayCopy)
                    
                    //  print("nahe")
                }else{
                    //    print("neast station= " + currentStation.name + " " + nearestStation![0].name + " " + nearestStation![1].name)
                    
                    currentStation = nearestStation![1]
                    result.append(nearestStation![1])
                    
                    arrayCopy = AdvancedStation.removeStaionFromStationArray(station: nearestStation![0], array: arrayCopy)
                    
                    // print()
                    // print("fern")
                }
            }else{
                break
            }
            
        }
        return result
    }
    
    private    func stationIncludetInArray(station: AdvancedStation, array: [AdvancedStation]) -> Bool{
        for stat in array{
            if(stat.name == station.name){
                return true
            }
        }
        return false
    }
    
    private func getDistanzbetweenToStations(start:AdvancedStation, end: AdvancedStation) -> Double{
        var position1 = CLLocation(latitude: start.cordinates!.latitude, longitude: start.cordinates!.longitude)
        var position2 = CLLocation(latitude: end.cordinates!.latitude, longitude: end.cordinates!.longitude)
        
        return position1.distance(from: position2)
    }
    
    private func getDistanzeBetweenCordinates(longitudeSart: Double, latitudeStart: Double,longitudeEnd: Double, latitudeEnd: Double)->Double{
        
        var posStart = CLLocation(latitude: latitudeStart, longitude: longitudeSart)
        var posEnd = CLLocation(latitude: latitudeEnd, longitude: longitudeEnd)
        return posStart.distance(from: posEnd)
    }
    
    private    func getNearstStation(stationArray:[AdvancedStation], currentStation: AdvancedStation) -> [AdvancedStation]?{
        var result = [AdvancedStation]()
        var positionLastStation = CLLocation(latitude:currentStation.cordinates!.latitude , longitude: currentStation.cordinates!.longitude)
        
        //  print()
        //  print()
        //    print(stationArray)
        
        if(stations.count != 0){
            var savedStation = stationArray[0]
            var secondSavedStation = stationArray[0]
            
            var previosDistance: Double
            var previosDistanceSecond: Double
            
            if(currentStation.name == stationArray[0].name){
                savedStation = stationArray[1]
            }
            
            result.append(savedStation)
            result.append(savedStation)
            result.append(savedStation)
            
            for station in stationArray{
                
                if(currentStation.name != station.name){
                    
                    previosDistance = getDistanzbetweenToStations(start: currentStation, end: savedStation)
                    var curentDistanze = getDistanzbetweenToStations(start: currentStation, end: station)
                    
                    var previosSecondDistance = getDistanzbetweenToStations(start: currentStation, end: secondSavedStation)
                    
                    /*   print("current distanze=" + curentDistanze.description
                     + " previus distanze=" + previosDistance.description)*/
                    
                    if(curentDistanze < previosDistance){
                        /*
                         print("station = " + station.name + " saved ="+savedStation.name)
                         print("current distanze=" + curentDistanze.description
                         + " previus distanze=" + previosDistance.description)
                         */
                        
                        result[0] = station
                        result[1] = savedStation
                        
                        secondSavedStation = savedStation
                        savedStation = station
                        
                    }else if (curentDistanze < previosSecondDistance){
                        result[1] = station
                        secondSavedStation = station
                        
                    }
                    
                }
            }
        }
        return result
        
    }
    
    private    func getallLinesForThisStation(station: StationTabel)->[Int]{
        var result = [Int]()
        for stat in stations{
            if(stat.name == station.name){
                return stat.subwayLines
                
            }
        }
        return result
    }
    
    private    func isValueInArray(input: [Int], value: Int)->Bool{
        for i in input{
            if(i == value){
                return true
            }
        }
        return false
    }
    
    private func getAllStationInThisLine(lineNumber:Int)->[AdvancedStation]{
        var result = [AdvancedStation]()
        for station in stations{
            if(isValueInArray(input: station.subwayLines, value: lineNumber)){
                result.append(station)
            }
        }
        return result
    }
    
    func calculate(start:StationTabel ,end: StationTabel)->Route?{
        var startStation = getStationByName(name: start.name)
        var endStation = getStationByName(name: end.name)
        
        
        var resultArray = calculation(start: startStation, end: endStation, route: Route())
        
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
    
    
    
    private    func getStations(){
        DispatchQueue.main.async {
            let database = DataBaseControll.instance
            
            var simpleStation = database.getStationsAsArray()
            self.lines = database.getLinesAsArray()
            for station in simpleStation {
                var newStation = AdvancedStation.convert(station: station)
                
                newStation.subwayLines = self.getLinesForStation(station: station)
                
                if(!self.isValueInArray(input: newStation.subwayLines, value: station.subwayLine)){
                    newStation.subwayLines.append(station.subwayLine)
                }
                
                self.stations.append(newStation)
                
            }
            // self.printStations()
            
        }
        
    }
    
    private    func convertToInt(input:Double)->Int{
        var comma = 1000000000000.0
        return Int(input*comma)
    }
    
    private    func makePositive(input:Int )->Int{
        if(input < 0){
            return input * -1
        }
        return input
    }
    
    private   func areCordinatesEqual(firstCordinates: CordinatesTabel, secondCordinates: CordinatesTabel )->Bool{
        var longDiffernz = convertToInt(input: firstCordinates.longitude)  - convertToInt(input: secondCordinates.longitude)
        var latDiffernz = convertToInt(input: firstCordinates.latitude)  - convertToInt(input: secondCordinates.latitude)
        
        longDiffernz = makePositive(input: longDiffernz)
        latDiffernz = makePositive(input: latDiffernz)
        
        // print(doublelat)
        //print(doublelong)
        if(longDiffernz <= RouteCalculator.allowedDistantceBetweenCorrdinates && latDiffernz  <= RouteCalculator.allowedDistantceBetweenCorrdinates){
            
            return true
        }
        return false
    }
    
    
    private    func getLinesForStation(station: StationTabel)->[Int]{
        var result = [Int]()
        for line in lines!{
            for cor in line.listOfcordinates{
                if(areCordinatesEqual(firstCordinates: cor, secondCordinates: station.cordinates!)){
                    if(!isValueInArray(input: result, value: line.subwayLine)){
                        result.append(line.subwayLine)
                    }
                }
            }
        }
        return result
    }
    /*
     func printStations(){
     for station in stations {
     print("Station: "+station.name+" lines:"+station.subwayLines.description)
     }
     }
     */
    private func getStationByName(name: String)->AdvancedStation{
        for station in stations {
            if(name == station.name){
                return station
            }
        }
        return AdvancedStation()
    }
    
    
}
