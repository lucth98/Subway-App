//
//  StationTabel.swift
//  Subway App
//
//  Created by Lucas on 05.01.23.
//

import Foundation
import RealmSwift


class StationTabel: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var subwayLine: Int = 0
    
    @Persisted var name: String = ""
    
    @Persisted var cordinates: CordinatesTabel?
    
    convenience init(subwayLine: Int, name: String, cordinates: CordinatesTabel? = nil) {
        self.init()
        self.subwayLine = subwayLine
        self.name = name
        self.cordinates = cordinates
    }
    
    
}
