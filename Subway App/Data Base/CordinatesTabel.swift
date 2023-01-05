//
//  CordinatesTabel.swift
//  Subway App
//
//  Created by Lucas on 05.01.23.
//

import Foundation
import RealmSwift

class CordinatesTabel: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var latitude: Double = 0.0
    @Persisted var longitude: Double = 0.0

    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}

