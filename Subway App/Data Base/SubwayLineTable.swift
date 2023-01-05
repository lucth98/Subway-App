//
//  SubwayLineTable.swift
//  Subway App
//
//  Created by Lucas on 05.01.23.
//

import Foundation
import RealmSwift


class SubwayLineTable: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var subwayLine: Int = 0
    
    @Persisted var listOfcordinates: List<CordinatesTabel>
    
}
