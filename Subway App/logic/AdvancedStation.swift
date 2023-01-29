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
    
    var cordinates: SimpleCordinates?
    
    static func convert(station: StationTabel)-> AdvancedStation{
        var result = AdvancedStation()
        
        result.name = station.name
        if let cor = station.cordinates{
            result.cordinates = SimpleCordinates.convertFromTabel(cordinatesTabel: cor)
        }else{
            result.cordinates = nil
        }
        
        
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
    
    static func  sortStationArray(arrayOfStations: [AdvancedStation]) -> [AdvancedStation]{
        return arrayOfStations.sorted{
            $0.name < $1.name
        }
    }
    
}


struct SimpleCordinates {
    
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    static func convertFromTabel(cordinatesTabel:CordinatesTabel)->SimpleCordinates{
        var result = SimpleCordinates()
        result.latitude = cordinatesTabel.latitude
        result.longitude = cordinatesTabel.longitude
        
        return result
    }
}

