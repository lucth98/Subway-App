//
//  RouteControllView.swift
//  Subway App
//
//  Created by Lucas on 28.01.23.
//

import Foundation
import UIKit

class RouteControllView: ViewController{
    var route:Route?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showRoute(){
       
            guard(self.route != nil)else{
                return
            }
            
            self.performSegue(withIdentifier: "drawRoute", sender: nil)
        
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        guard let routeViewController = segue.destination as? RouteView
        else{
            return
        }
        
        if(route != nil){
            routeViewController.route = self.route!
            
        }
    }
}
