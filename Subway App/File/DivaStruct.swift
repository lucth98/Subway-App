//
//  DivaStruct.swift
//  Subway App
//
//  Created by Lucas on 30.01.23.
//

import Foundation

struct DivaStruct: Codable{
    
    var dataArray: [DivaData]
    
    
   
    /*
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let data = try? [DivaData](from: decoder) {
            dataArray = data
        }
    }*/
}


struct DivaData:Codable{
    var DIVA: Int
    var PlatformText: String
    var Municipality: String
    var Longitude: Double
    var Latitude: Double
}
