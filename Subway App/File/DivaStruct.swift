//
//  DivaStruct.swift
//  Subway App
//
//  Created by Lucas on 30.01.23.
//

import Foundation

struct DivaStruct: Codable{
    
    var dataArray: [DivaData]

}


struct DivaData:Codable{
    var DIVA: Int
    var PlatformText: String
    var Municipality: String
    var Longitude: Double
    var Latitude: Double
}
