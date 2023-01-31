//
//  TrainAPI.swift
//  Subway App
//
//  Created by Lucas on 30.01.23.
//

import Foundation



class TrainAPI{
    var baseUrl = "https://www.wienerlinien.at/ogd_realtime/monitor?diva="

    func getTrains(diva:Int , _ completionHandler:@escaping (TrainData?,NetworkError?)->Void){
        
        var urlString = baseUrl + diva.description
        var url = URL(string: urlString)!
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            
            var errorResult: NetworkError?
            var result:TrainData?
            
            print("data:")
            print(data ?? "no Data")
            
            let stringValue = String(decoding: data ?? Data(), as: UTF8.self)
            print(stringValue)
            
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
                           
                            let recivedInfo:TrainData =  try jsonDecoder.decode(TrainData.self, from: data!)
                            print("decodet")
                            result = recivedInfo
                            
                        }catch{
                            print("decoding Error")
                           print("caught: \(error)")
                            
                            errorResult = NetworkError.responceDataFormatIsInFalseFormatError(error.localizedDescription)
                        }
                    }
                    //data is nil
                } else{
                    errorResult = NetworkError.noSuccesfulResponseCodeError("Responce Code = " + httpResponce.statusCode.description)
                }
            } else{
                errorResult = NetworkError.unknownError("http Responce can not be readed")
            }
            
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
            
            DispatchQueue.main.async {
                
                completionHandler(result,errorResult)
            }
        }
        
        dataTask.resume()
    }
}
