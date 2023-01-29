//
//  internetView.swift
//  Subway App
//
//  Created by Lucas on 28.01.23.
//

import Foundation
import UIKit
import WebKit

class InternetView: ViewController, WKNavigationDelegate{
    
    var urlOfWebShop = "https://shop.wienmobil.at/products"
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBAction func openInBrowser(){
        if let url = URL(string: urlOfWebShop) {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buy Ticket"
        
        webView.navigationDelegate = self
        
        urlLabel.text = urlOfWebShop
        
        let url = URL(string: urlOfWebShop)!
        
        webView.load(URLRequest(url:url))
        
        
    }
    
    
    /*
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        DispatchQueue.main.async {
            
            if let urlStr = navigationAction.request.url?.absoluteString{
            
                self.urlLabel.text = urlStr
            }
            
        }
        decisionHandler(.allow)
    }*/
    
}
