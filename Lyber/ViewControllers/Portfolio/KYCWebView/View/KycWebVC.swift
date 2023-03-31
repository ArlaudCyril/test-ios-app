//
//  KycWebVC.swift
//  Lyber
//
//  Created by sonam's Mac on 07/07/22.
//

import UIKit
import WebKit

class KycWebVC: ViewController,WKNavigationDelegate {
    //MARK: - Variables
    var kycWebVC  = KycWebVM()
    var Ubalurl = String()
    //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }

	//MARK: - SetUpUI
    override func setUpUI(){
        let myURL = URL(string: Ubalurl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.navigationDelegate = self
        
        backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
    }
}

extension KycWebVC {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish URL: \(String(describing: webView.url))")
        let webString = webView.url?.absoluteString ?? ""
        kycWebVC.kycDoneApi(completion: {[weak self]response in
            self?.navigationController?.popViewController(animated: true)
        })
        if webString.contains("https://lyber.com/kyc?"){
            kycWebVC.kycDoneApi(completion: {[weak self]response in
                self?.navigationController?.popViewController(animated: true)
            })
            
        }
    }
}

//MARK: - objective functions
extension KycWebVC{
    @objc func backBtnAct(){
        if webView.canGoBack{
            webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
