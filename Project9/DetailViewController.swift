//
//  DetailViewController.swift
//  Project7
//
//  Created by Hafizh Caesandro Kevinoza on 10/04/22.
//

import UIKit
// import WebKit to dsiplay web content
import WebKit

class DetailViewController: UIViewController {
    // webView = An object that displays interactive web content, such as for an in-app browser.
    var webView: WKWebView!
    // fill detailItem with codable struct
    var detailItem: Petition?
    
    override func loadView() {
        // WKWebView() = An object that displays interactive web content, such as for an in-app browser.
        webView = WKWebView()
        // view = The view that the controller manages.
        // fill view with webView value
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // unwrap otional detailtem
        guard let detailItem = detailItem else { return }
        // contains everything needed to show the page, and that's passed in to the web view's
        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        body {
                            font-size: 150%;
                            text-align: justify;
                            text-justify: inter-word;
                        }
        
                        h2 {
        
                        }
                    </style>
            </head>
        <body>
            <h3>\(detailItem.title)</h3>
            <p>\(detailItem.body)</p>
        </body>
        </html>
        """
        // loadHTMLString = Loads the contents of the specified HTML string and navigates to it.
        webView.loadHTMLString(html, baseURL: nil)
    }

}
