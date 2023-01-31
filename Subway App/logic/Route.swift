//
//  Route.swift
//  Subway App
//
//  Created by Lucas on 16.01.23.
//

import Foundation

struct Route{
  
    var stations: [AdvancedStation]
   
    var lineNumbers:[Int]
  
    func getLength()->Int{
       
        return stations.count
    }
    
    init(){
        
        self.stations = [AdvancedStation]()
        self.lineNumbers = [Int]()
    }
    
    mutating func addStation(station: AdvancedStation){
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
    
    func containStation(newStation:AdvancedStation)->Bool{
        for sation in stations {
            if(sation.name == newStation.name){
                return true
            }
        }
        return false
    }
    
    func isEmpty()->Bool{
        return lineNumbers.count == 0 && stations.count == 0
        
    }
}
