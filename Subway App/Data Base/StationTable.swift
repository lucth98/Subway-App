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
    
    
    
    
}
