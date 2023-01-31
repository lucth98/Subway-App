//
//  FileReader.swift
//  Subway App
//
//  Created by Lucas on 30.01.23.
//

import Foundation

class FileReader{
    //realise test
    private var diva: DivaStruct?
    
    
    func getDiva(stationName:String)->Int{
        if let data = diva?.dataArray{
            for divaData in data{
                if(divaData.PlatformText == stationName){
                    return divaData.DIVA
                }
            }
            return -1
        }else{
            return -1
        }
    }
    
    func read(){
        
        do{
            var filePath = try Bundle.main.path(forResource: "StationDIVA", ofType: "json")
            var data     = try Data(contentsOf: URL(fileURLWithPath: filePath!))
            var jsonDecoder = JSONDecoder()
            var decodedData: DivaStruct  = try jsonDecoder.decode(DivaStruct.self, from: data)
            
            diva = decodedData
         //   print(decodedData)
        }catch{
            print("file Error")
            print("caught: \(error)")
        }
    }
    
}
