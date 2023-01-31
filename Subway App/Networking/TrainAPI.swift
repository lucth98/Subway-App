//
//  TrainAPI.swift
//  Subway App
//
//  Created by Lucas on 30.01.23.
//

import Foundation



class TrainAPI{
    var baseUrl = "https://www.wienerlinien.at/ogd_realtime/monitor?diva="
    
    
 
    
    private func convertAnyToData(var input: Any)->Data?{
        if let jsonData = try? JSONSerialization.data(withJSONObject:input){
          
            return jsonData
        }else{
          
            return nil
        }
    }
    
    
    private func convertAnyToArray(input:Any)->[Any]?{
        if var convertet = convertAnyToData(var: input){
            do{
                if    var dictionaryFromData = try JSONSerialization.jsonObject(with: convertet, options: []) as? [Any]{
                    return dictionaryFromData 
                }
                 
                }
            catch{
               print(" \(error)")
            }
        }
            return nil
    }
    
    
    
    private func convertAnyToDictonary(input:Any)->[String:Any]?{
        if var convertet = convertAnyToData(var: input){
            do{
                if    var dictionaryFromData = try JSONSerialization.jsonObject(with: convertet, options: []) as? [String:Any]{
                    return dictionaryFromData
                }
                 
                }
            catch{
               print(" \(error)")
            }
        }
            return nil
    }
    
    
    
    func decode(data:Data){
        do{
            var dictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: []) //as! [String:Any]
            print(type(of: dictionaryFromJSON))
            if var object = dictionaryFromJSON as? [String:Any]{
                print("is dic")
                print(object.count)
                
                
                var dataAny = object["data"]
                print(type(of: dataAny))
                
                if var dataDecodet = convertAnyToDictonary(input: dataAny){
                    print(type(of: dataDecodet))
                    var monitorAny = dataDecodet["monitors"]
                    print(type(of: monitorAny))
                    print(monitorAny)
                    
                    if var monitorDecodet = convertAnyToDictonary(input: monitorAny){
                       print("monitor")
                        print(type(of: monitorDecodet))
                    }else{
                        print("monitor is nil")
                    }
                    
                }
                
                /*
                if var dataSection = convertAnyToData(var: dataAny){
                    print(type(of: dataSection))
                    var dictionaryFromData = try JSONSerialization.jsonObject(with: dataSection, options: []) as? [String:Any]
                    print(type(of: dictionaryFromData))
                    
                    var monitors = dictionaryFromData?["monitors"]
                    print(type(of: monitors))
                    
                    
                    
                    
                    
                }
                 */
                
                
                
            } else if var object = dictionaryFromJSON as? [Any]{
                print("is array")
            }else{
                print("error decode")
            }
            
            
        }catch{
            print("caught: \(error)")
        }
    }
    
    
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
