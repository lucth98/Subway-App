//
//  ViewController.swift
//  Subway App
//
//  Created by Lucas on 19.12.22.
//

import UIKit

class ViewController: UIViewController {
    
    //test
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        apiInit(networking: Networking())
    }
    
    func apiInit(networking: Networking){
        
        networking.getSubwaysAndStations(returnFunction)
        
    }
    
    func returnFunction(_ networkError: NetworkError?){
      
            if(networkError != nil){
                /*
                DispatchQueue.main.async {
                    let dataBase = DataBaseControll.instance
                    
                    if(dataBase.isRealmempty()){
                        
                        let alert:UIAlertController=UIAlertController(title: "No Data",
                                                                      message: "please check your Internetconnection",
                                                                      preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                 
                 */
                
                
                switch(networkError!){
                case NetworkError.networkIsOfflineError:
                    drawAlert("Network is Offline", "\(networkError!)")
                case NetworkError.noSuccesfulResponseCodeError:
                    drawAlert("Non Succesful Responce Code", "\(networkError!)")
                case NetworkError.responceDataFormatIsInFalseFormatError:
                    drawAlert("Recived Data is in false Format", "\(networkError!)")
                case NetworkError.unknownError:
                    drawAlert("Non Succesful Responce Code", "\(networkError!)")
                case NetworkError.savingError:
                    drawAlert("Non Succesful Responce Code", "\(networkError!)")
                }
                
            }
    }
    
    func drawAlert(_ titleOfAlert:String,_ messageOfAlert:String){
        let alert:UIAlertController=UIAlertController(title: titleOfAlert,
                                                      message: messageOfAlert,
                                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive))
        
        self.present(alert, animated: true, completion: nil)
    }
}

