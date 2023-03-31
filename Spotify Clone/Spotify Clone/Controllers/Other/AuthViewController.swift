//
//  AuthViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit
import WebKit
class AuthViewController: UIViewController {
    
    public var completionHandler: ((Bool) -> Void)?
    
    private lazy var webView : WKWebView = {
        
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config  = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        guard let url = AuthManager.shared.sigInURL else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        webView.frame = self.view.bounds
    }
    
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
            
        }
        
        let component = URLComponents(string: url.absoluteString)
        
        
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else {
            
            return
        }
        
        
        webView.isHidden = true
        print("Code \(code)" )
        
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
            
        }
        

    }
}
