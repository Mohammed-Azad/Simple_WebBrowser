//
//  ViewController.swift
//  Simple_WebBrowser
//
//  Created by Mohammed's MacBook on 6/25/24.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["github.com/Mohammed-Azad","linkedin.com/in/mhammad-azad-aa1a65232/","stackoverflow.com/users/19226214/mohammed-azad"]
    //Delegation is what's called a programming pattern – a way of writing code
     override func loadView() {
         webView = WKWebView()
         // navigationDelegate = self -> when any web page navigation happens, please tell me – the current view controller.
         webView.navigationDelegate = self
         view = webView
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self , action: #selector(openTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButton))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [ progressButton,spacer,refresh]
        navigationController?.isToolbarHidden = false
        
        // it's called KVO(key,value,observable) use for estimating the progress for the progress view
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),options: .new, context: nil)
        
        
        let url = URL(string: "https://" + websites[0])!
        print(url)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    @objc func backButton(){
          if webView.canGoBack {
                      webView.goBack()
                  } else {
                      // If there is no previous page, pop the view controller
                      navigationController?.popViewController(animated: true)
                  }
              
      }
    @objc func openTapped() {
          let ac = UIAlertController(title: "Open page ...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default,handler: openPage))
        }
          
          ac.addAction(UIAlertAction(title: "cancel ", style: .cancel))
          ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
          present(ac,animated: true)
      }
      func openPage(action: UIAlertAction){
          guard let actionTitle = action.title else{return}
          guard let url = URL(string: "https://" + actionTitle) else {return}
          webView.load(URLRequest(url: url))
      }
        // show title in center of navigation bar
      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          title = webView.title
      }
    
    // also it's KVO to put the progress to the progress view
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            // typeCast is used because estimatedProgress is double and progress is float
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}

