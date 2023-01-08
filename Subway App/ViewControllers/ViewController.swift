//
//  ViewController.swift
//  Subway App
//
//  Created by Lucas on 19.12.22.
//

import UIKit

class ViewController: UIViewController {
    var networking: Networking?
    
    //test
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        networking = Networking()
        apiInit()
    }
    
    func apiInit(){
        guard (networking != nil)else{
            return
        }
        networking!.getSubwaysAndStations(returnFunction)
        
    }
    
    func returnFunction(_ networkError: NetworkError?, _ networking: Networking ){
      
            if(networkError != nil){
                
                DispatchQueue.main.async {
                    let dataBase = DataBaseControll.instance
                    
                    if(dataBase.isRealmempty()){
                        
                        self.retryAlert(networking: networking)
                    }
                }
                 
                 
                switch(networkError!){
                case NetworkError.networkIsOfflineError:
                    drawAlert("Network is Offline", "\(networkError!)")
                case NetworkError.noSuccesfulResponseCodeError:
                    drawAlert("Non Succesful Responce Code", "\(networkError!)")
                case NetworkError.responceDataFormatIsInFalseFormatError:
                    drawAlert("Recived Data is in false Format", "\(networkError!)")
                case NetworkError.unknownError:
                    drawAlert("Unknown Error", "\(networkError!)")
                case NetworkError.savingError:
                    drawAlert("Non Succesful Responce Code", "\(networkError!)")
                }
                
            }
    }
    
    func retryAlert(networking: Networking){
        let alert:UIAlertController=UIAlertController(title: "Data could not be downloaded",
                                                      message: "please ensure that you have an internet connection",
                                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive))
        
        self.present(alert, animated: true){
            self.apiInit()
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

