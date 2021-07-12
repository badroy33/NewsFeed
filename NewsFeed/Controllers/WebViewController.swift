//
//  WebViewController.swift
//  NewsFeed
//
//  Created by Maksym Levytskyi on 10.07.2021.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    
    static let identifier = "WebViewController"
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: URL!
    var sourceName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: url))
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
