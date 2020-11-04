//
//  ArticleDetailsViewController.swift
//  Diggy
//
//  Created by Igor Gorbachov on 29/10/20.
//

import UIKit
import WebKit

class ArticleDetailsCiewController: UIViewController {
    
    var article: Article? {
        didSet {
            if let article = article {
                loadURL(article.url)
            }
        }
    }
    
    lazy var webView: WKWebView = {
       let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    private func setupView() {
        view.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func loadURL(_ url: String) {
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
    }
}
