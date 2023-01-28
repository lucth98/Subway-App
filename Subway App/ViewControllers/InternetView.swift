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
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buy Ticket"
        
        webView.navigationDelegate = self
        
        urlLabel.text = urlOfWebShop
        
        let url = URL(string: urlOfWebShop)!
        
        webView.load(URLRequest(url:url))
        
        
    }
    
}
