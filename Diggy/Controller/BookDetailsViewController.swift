//
//  BookDetailsCiewController.swift
//  Diggy
//
//  Created by Igor Gorbachov on 10/11/20.
//

import Foundation
import WebKit

class BookDetailsViewController: UIViewController {
    
    var book: Book? {
        didSet {
            if let book = book {
                loadURL(book.amazonProductURL)
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
