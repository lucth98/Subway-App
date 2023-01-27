//
//  AdvancedStation.swift
//  Subway App
//
//  Created by Lucas on 26.01.23.
//

import Foundation

struct AdvancedStation{
    
    var subwayLines: [Int] = []
    
    var name: String = ""
    
    var cordinates: CordinatesTabel?
    
    static func convert(station: StationTabel)-> AdvancedStation{
        var result = AdvancedStation()
        
        result.name = station.name
        result.cordinates = station.cordinates
    
        return result
    }
    
    static func removeStaionFromStationArray(station:AdvancedStation, array: [AdvancedStation] )->[AdvancedStation]{
        
        var result = array
        
        
        for (index,element) in result.enumerated(){
            if(element.name == station.name){
                result.remove(at: index)
            }
        }
        return result
    }
    
    static func removeMultipleStaionsFromStationArray(stations:[AdvancedStation], array: [AdvancedStation] )->[AdvancedStation]{
        var result = array
        for station in stations {
          result =  removeStaionFromStationArray(station: station, array: result)
        }
        return result
    }
    
}

