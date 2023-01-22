//
//  Route.swift
//  Subway App
//
//  Created by Lucas on 16.01.23.
//

import Foundation

struct Route{
    var lines: [SubwayLineTable]
    var stations: [StationTabel]
    var newestLie: SubwayLineTable?
    var lineNumbers:[Int]
  
    func getLength()->Int{
       
        return stations.count
    }
    
    init(){
        self.lines = [SubwayLineTable]()
        self.stations = [StationTabel]()
        self.lineNumbers = [Int]()
    }
    
    mutating func addStation(station: StationTabel){
        stations.append(station)
    }
  
    mutating func addline(line: SubwayLineTable){
        lines.append(line)
    }
    
    mutating func setNearestLine(line: SubwayLineTable){
        newestLie = line
    }
    
    mutating func addLineNumber(line: Int){
        lineNumbers.append(line)
    }
    
    func hasThisLine(line:Int)->Bool{
        for li in lineNumbers{
            if(li == line){
                return true
            }
        }
    
        return false
    }
    
    func hasLoops()->Bool{
        for station in stations{
            var count = 0
            for line in lines{
                for corr in line.listOfcordinates{
                    if(corr.latitude == station.cordinates?.latitude && corr.longitude == station.cordinates?.longitude){
                        count += 1
                    }
                }
            }
            if(count > 2){
                return true
            }
        }
        return false
    }
    
    func containStation(newStation:StationTabel)->Bool{
        for sation in stations {
            if(sation == newStation){
                return true
            }
        }
        return false
    }
    
    func isEmpty()->Bool{
        return lineNumbers.count == 0 && stations.count == 0 //&& newestLie == nil
        
    }
}
