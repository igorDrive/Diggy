//
//  MovieDetailsViewController.swift
//  Diggy
//
//  Created by Igor Gorbachov on 13/11/20.
//

import Foundation
import WebKit

class MovieDetailsViewController: UIViewController {
    
    var movie: Movie? {
        didSet {
            if let movie = movie {
                loadURL(movie.link.url)
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
