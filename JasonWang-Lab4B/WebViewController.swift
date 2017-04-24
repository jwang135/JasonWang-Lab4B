//
//  WebViewController.swift
//  JasonWang-Lab4B
//
//  Created by J Wang on 3/9/17.
//  Copyright © 2017 J Wang. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{
    
    var webView: WKWebView!
    var urlInsert: String! = nil
    
    //Loads the IMDB page of the favorited movie
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let webView = WKWebView(frame: self.view.bounds)
        
        let movieUrl = URL(string:"http://www.imdb.com/find?ref_=nv_sr_fn&q=\(urlInsert!)&s=all")!
        let myURL = URLRequest(url: movieUrl)
        webView.load(myURL)
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
