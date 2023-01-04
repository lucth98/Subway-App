//
//  Networking.swift
//  Subway App
//
//  Created by Lucas on 19.12.22.
//

import Foundation

class Networking{
    
    let urlAPI1String = "https://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:HALTESTELLEWLOGD&srsName=EPSG:4326&outputFormat=json"
    let urlAPI2String = "https://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:UBAHNOGD,ogdwien:UBAHNHALTOGD&srsName=EPSG:4326&outputFormat=json"
    
    let urlStationAPI: URL
    let urlSubwayApi: URL

    
    
    init() {
        self.urlStationAPI = URL(string: urlAPI1String)!
        self.urlSubwayApi = URL(string: urlAPI2String)!
    }
    
    
    
    func getStations(){
        var urlRequest: URLRequest = URLRequest(url: urlStationAPI)
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            
        }
        
    }
    
    
    func getSubway(){
        var urlRequest: URLRequest = URLRequest(url: urlSubwayApi)
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            
            print("data:")
            print(data ?? "no Data")
            
            print("response:")
            print(response ?? "no Response")
            
            print("error:")
            print(error ?? "no Error")
            
            
            
            print("decoded Data:")
           
            
            let stringValue = String(decoding: data!, as: UTF8.self)
            print(stringValue)
            
         
            
            
        }
        
        dataTask.resume()
        
        
        
    }
    
    
    
    
    
    
}
