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
    
    func loadWebPage(){
        DispatchQueue.main.async {
            let url = URL(string: self.urlOfWebShop)!
            let request = URLRequest(url:url)
            
            self.webView.load(request)
            
        }
    }
    
   
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buy Ticket"
        
        webView.navigationDelegate = self
        
        loadWebPage()
    }
    
}
