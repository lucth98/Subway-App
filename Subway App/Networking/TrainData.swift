//
//  TrainData.swift
//  Subway App
//
//  Created by Lucas on 30.01.23.
//

import Foundation


/*
struct TrainData{
    var targed:String
    var time:String
}*/

struct TrainData:Codable{
    var data:TrainDatainput
    var message:TrainMessage
    
    
}

struct TrainDatainput:Codable{
    var monitors:[TrainLine]
}



struct TrainLine:Codable{
    var locationStop: TrainLocationStop
    var lines: [TrainLineInf]
    var attributes:empty?
}



struct TrainLineInf:Codable{
    var name:String
    var towards:String
    var direction:String
    var platform:String
    var richtungsId:String
    var barrierFree:Bool
    var realtimeSupported:Bool
    var trafficjam:Bool
    var departures:TrainDepartures
}

struct TrainDepartures:Codable{
    var departure:[TrainDeparture]
    var type: String?
    var lineId:Int?
}

struct TrainDeparture:Codable{
    var departureTime:TrainDepartureTime
    var vehicle:TrainVehicle?
}

struct TrainDepartureTime:Codable{
    var timePlanned:String
    var timeReal:String?
    var countdown:Int
    
}

struct TrainVehicle:Codable{
    var name:String
    var towards:String
    var direction:String
    var richtungsId:String
    var barrierFree:Bool
    var foldingRamp:Bool?
    var foldingRampType:String?
    var realtimeSupported:Bool
    var trafficjam:Bool
    var type:String
    var attributes:empty?
    var linienId:Int
}

struct empty:Codable{
    
}
struct TrainLocationStop:Codable{
    var type: String
    var geometry: TrainGeometry
    var properties: TrainProperties
}

struct TrainProperties:Codable{
    var name:String
    var title:String
    var municipality:String
    var municipalityId:Int
    var type:String
    var coordName:String
    var gate: String?
    var attributes:TrainAttributes
}

struct TrainGeometry:Codable{
    var type: String
    var coordinates: [Double]
}


struct TrainAttributes:Codable{
    var rbl:Int?
}

struct TrainMessage:Codable{
    var value:String
    var messageCode:Int
    var serverTime:String
}

