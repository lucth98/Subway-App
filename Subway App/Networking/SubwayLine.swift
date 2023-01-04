//
//  SubwayLine.swift
//  Subway App
//
//  Created by Lucas on 04.01.23.
//

import Foundation

struct SubwayInformation: Codable{
    var type: String
    var totalFeatures: Int
    var features: [SubwayLineData]
    var crs: SubwayCRS
}

struct SubwayCRS: Codable{
    var type: String
    var properties: SubwayCRSProperties
}

struct SubwayCRSProperties: Codable{
    var name: String
}

struct SubwayLineData: Codable{
    var type: String
    var id: String
    var geometry: SubwayLine
    var geometry_name: String
    var properties: SubwayLineProperties?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.id = try container.decode(String.self, forKey: .id)
        self.geometry = try container.decode(SubwayLine.self, forKey: .geometry)
        self.geometry_name = try container.decode(String.self, forKey: .geometry_name)
        self.properties = try container.decodeIfPresent(SubwayLineProperties.self, forKey: .properties)
    }
}

struct SubwayLine: Codable{
    var type: String
    var coordinates: ArrayOrNotArray//[coordinate]
  
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.coordinates = try container.decode(ArrayOrNotArray.self, forKey: .coordinates)
    }
    
    
}

struct ArrayOrNotArray: Codable{
   // var value: Any
    var cordinate: [Double]?
    var multiCordinate: [[Double]]?
    
    init(from decoder: Decoder) throws {
        
        if let mc = try? [[Double]](from: decoder) {
            multiCordinate = mc
            cordinate = nil
        }
        
        if let cor = try? [Double](from: decoder) {
            multiCordinate = nil
            cordinate = cor
        }
    }
    
    
}

struct SubwayLineProperties: Codable{
    var OBJECTID: Int
    var LINFO:Int
    var EROEFFNUNG_JAHR: Int
    var EROEFFNUNG_MONAT: Int
    var SE_ANNO_CAD_DATA: Int?
    
    var HSTNR: Int?
    var HTXT: String?
    var HBEM: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.OBJECTID = try container.decode(Int.self, forKey: .OBJECTID)
        self.LINFO = try container.decode(Int.self, forKey: .LINFO)
        self.EROEFFNUNG_JAHR = try container.decode(Int.self, forKey: .EROEFFNUNG_JAHR)
        self.EROEFFNUNG_MONAT = try container.decode(Int.self, forKey: .EROEFFNUNG_MONAT)
        self.SE_ANNO_CAD_DATA = try container.decodeIfPresent(Int.self, forKey: .SE_ANNO_CAD_DATA)
        self.HSTNR = try container.decodeIfPresent(Int.self, forKey: .HSTNR)
        self.HTXT = try container.decodeIfPresent(String.self, forKey: .HTXT)
        self.HBEM = try container.decodeIfPresent(String.self, forKey: .HBEM)
    }
}


/*
 struct coordinate: Codable{
 var latitude: Double
 var longitude: Double
 
 init(from decoder: Decoder) throws {
 // let container = try decoder.container(keyedBy: CodingKeys.self)
 //self.latitude = try container.decode(Double.self, forKey: .latitude)
 //self.longitude = try container.decode(Double.self, forKey: .longitude)
 
 
 var container = try decoder.unkeyedContainer()
 latitude = try container.decode(Double.self)
 longitude = try container.decode(Double.self)
 
 }
 
 
 }
 */
