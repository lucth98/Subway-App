//
//  Route.swift
//  Subway App
//
//  Created by Lucas on 16.01.23.
//

import Foundation

struct Route{
    var lines: [SubwayLineTable]
    var sations: [StationTabel]
    var newestLie: SubwayLineTable?
  
    func getLength()->Int{
        var result = 0
        
        for line in lines{
            for corr in line.listOfcordinates{
                result+=1
            }
        }
        return result
    }
    
    init(){
        self.lines = [SubwayLineTable]()
        self.sations = [StationTabel]()
    }
    
    mutating func addStation(station: StationTabel){
        sations.append(station)
    }
  
    mutating func addline(line: SubwayLineTable){
        lines.append(line)
    }
    
    mutating func setNearestLine(line: SubwayLineTable){
        newestLie = line
    }
    
    func hasLoops()->Bool{
        for station in sations{
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
        for sation in sations {
            if(sation == newStation){
                return true
            }
        }
        return false
    }
    
    func isEmpty()->Bool{
        return lines.count == 0 && sations.count == 0 && newestLie == nil
    }
}
