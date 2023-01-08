//
//  Networking.swift
//  Subway App
//
//  Created by Lucas on 19.12.22.
//

import Foundation
import RealmSwift

class Networking{
    
    let urlAPI1String = "https://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:HALTESTELLEWLOGD&srsName=EPSG:4326&outputFormat=json"
    let urlAPI2String = "https://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:UBAHNOGD,ogdwien:UBAHNHALTOGD&srsName=EPSG:4326&outputFormat=json"
    
    let urlStationAPI: URL
    let urlSubwayApi: URL

    
    
    init() {
        self.urlStationAPI = URL(string: urlAPI1String)!
        self.urlSubwayApi = URL(string: urlAPI2String)!
    }
    
    func getSubwaysAndStations(_ completionHandler:@escaping (NetworkError?)->Void){
        var urlRequest: URLRequest = URLRequest(url: urlSubwayApi)
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            
            var errorResult: NetworkError?
            
            print("data:")
            print(data ?? "no Data")
            
            print("response:")
            print(response ?? "no Response")
            
            print("error:")
            print(error ?? "no Error")
            
            if let httpResponce = response as? HTTPURLResponse{
                print("code:")
                print(httpResponce.statusCode)
                
                if(!(httpResponce.statusCode > 400 && httpResponce.statusCode < 600)){
                    
                    
                    if(data != nil){
                        
                        
                        
                        let jsonDecoder = JSONDecoder()
                        do{
                            let recivedInfo:SubwayInformation =  try jsonDecoder.decode(SubwayInformation.self, from: data!)
                            print("decoded Data:")
                            print(recivedInfo)
                            do{
                                try self.saveDataInDB(recivedInfo)
                            }catch{
                                print("dataBase Error")
                                print("caught: \(error)")
                                
                                errorResult = NetworkError.savingError(error.localizedDescription)
                                
                            }
                            
                        }catch{
                            print("decoding Error")
                            print("caught: \(error)")
                            
                            errorResult = NetworkError.responceDataFormatIsInFalseFormatError(error.localizedDescription)
                        }
                    }else{
                        //data is nil
                        
                        if let errorNs = error as NSError?{
                            var errorString:String = errorNs.localizedDescription
                            print("ERROR to String: ")
                            print(errorString)
                            
                            switch errorString{
                            case "The Internet connection appears to be offline.":
                                errorResult = NetworkError.networkIsOfflineError(errorString)
                            default:
                                errorResult = NetworkError.unknownError(errorString)
                            }
                            
                        }
                    }
                } else{
                    errorResult = NetworkError.noSuccesfulResponseCodeError("Responce Code = " + httpResponce.statusCode.description)
                }
            } else{
                errorResult = NetworkError.unknownError("http Responce can not be readed")
            }
            
            DispatchQueue.main.async {
              
                completionHandler(errorResult)
            }
        }
        
        dataTask.resume()
    }
    
    func saveDataInDB(_ data: SubwayInformation){
        DispatchQueue.main.async {
            
            let dataBase = DataBaseControll.instance
            
            let subwayArray = data.features
            
            for subwayData in subwayArray{
                if(subwayData.properties != nil){
                    if(subwayData.properties?.HTXT != nil){ // data set is a Station
                        var stationTableEntry: StationTabel
                        
                        var stationName = subwayData.properties?.HTXT
                        var subwayLine = subwayData.properties?.LINFO
                        
                        var latitude: Double = subwayData.geometry.coordinates.cordinate?[1] ?? 0.0
                        var longitude: Double = subwayData.geometry.coordinates.cordinate?[0] ?? 0.0
                        
                        var cordinates = CordinatesTabel(latitude: latitude, longitude: longitude)
                        
                        stationTableEntry = StationTabel(subwayLine: subwayLine ?? -1, name: stationName ?? "Error: no Name", cordinates: cordinates)
                        
                        dataBase.saveStation(stationTableEntry)
                        
                    }else{ // data set is a SubwayLine
                        
                        var subwayLine = subwayData.properties?.LINFO ?? -1
                        
                        var cordinatesList: List<CordinatesTabel> = List()
                        
                        var arrayOfCordinates = subwayData.geometry.coordinates.multiCordinate
                        
                        for i in stride(from: 0, to: arrayOfCordinates?.count ?? 0, by: 1){
                            
                            var longitude = arrayOfCordinates?[i][0]
                            var latitude = arrayOfCordinates?[i][1]
                            
                            var cordinate = CordinatesTabel(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
                            
                            cordinatesList.append(cordinate)
                        }
                        
                        var subwayLineTabelEntry = SubwayLineTable(subwayLine: subwayLine, listOfcordinates: cordinatesList)
                        
                        dataBase.saveSubwayLine(subwayLineTabelEntry)
                    }
                }
                
            }
            
            
            
            
        }
    }
}
