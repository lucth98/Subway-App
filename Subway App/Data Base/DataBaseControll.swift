//
//  DataBaseControll.swift
//  Subway App
//
//  Created by Lucas on 05.01.23.
//

import Foundation
import RealmSwift

class DataBaseControll{
    
    static let instance = DataBaseControll()
    
    var realm: Realm
    
    private init(){
        realm = try! Realm()
    }
    
    func saveStation(_ station: StationTabel){
        try! realm.write {
            realm.add(station)
        }
    }
    
    func saveCordinates(_ cordinates: CordinatesTabel){
        try! realm.write {
            realm.add(cordinates)
        }
    }
    
    func saveSubwayLine(_ subwayLine: SubwayLineTable ){
        try! realm.write {
            realm.add(subwayLine)
        }
    }
    
    func getAllStations()-> Results<StationTabel>{
        return realm.objects(StationTabel.self)
    }
    
    func getAllCordinates()->Results<CordinatesTabel>{
        return realm.objects(CordinatesTabel.self)
    }
    
    func getAllSubwayLines()->Results<SubwayLineTable>{
        return realm.objects(SubwayLineTable.self)
    }
    
    func resetDatabase(){
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func isRealmempty()->Bool{
        return realm.isEmpty
    }
    
}
