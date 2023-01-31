//
//  internetView.swift
//  Subway App
//
//  Created by Lucas on 28.01.23.
//

import Foundation
import UIKit
import WebKit

class InternetView: ViewController, WKNavigationDelegate, WKUIDelegate{
    
    var urlOfWebShop = "https://shop.wienmobil.at/products"
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBAction func openInBrowser(){
        if let url = URL(string: urlOfWebShop) {
            UIApplication.shared.open(url)
        }
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
           
        urlLabel.text = webView.url?.description
    }
    
   
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buy Ticket"
        
        webView.navigationDelegate = self
        
        let url = URL(string: urlOfWebShop)!
        let request = URLRequest(url:url)
        
        webView.load(request)
    }
    
}
