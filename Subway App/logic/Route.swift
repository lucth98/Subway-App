//
//  Route.swift
//  Subway App
//
//  Created by Lucas on 16.01.23.
//

import Foundation

struct Route{
  
    var stations: [StationTabel]
   
    var lineNumbers:[Int]
  
    func getLength()->Int{
       
        return stations.count
    }
    
    init(){
        
        self.stations = [StationTabel]()
        self.lineNumbers = [Int]()
    }
    
    mutating func addStation(station: StationTabel){
        stations.append(station)
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
    
    func containStation(newStation:StationTabel)->Bool{
        for sation in stations {
            if(sation == newStation){
                return true
            }
        }
        return false
    }
    
    func isEmpty()->Bool{
        return lineNumbers.count == 0 && stations.count == 0
        
    }
}
