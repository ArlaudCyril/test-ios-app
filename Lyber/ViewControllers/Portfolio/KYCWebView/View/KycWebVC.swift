//
//  KycWebVC.swift
//  Lyber
//
//  Created by sonam's Mac on 07/07/22.
//

import UIKit
import WebKit

class KycWebVC: NotSwipeGesture,WKNavigationDelegate, WKUIDelegate {
    //MARK: - Variables
    var Ubalurl = String()
	var webViewRedirection: WKWebView!
    //MARK: - IB OUTLETS
    @IBOutlet var webViewHome: WKWebView!
	@IBOutlet var changeInformationsBtn: PurpleButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }

	//MARK: - SetUpUI
    override func setUpUI(){
        let myURL = URL(string: Ubalurl)
        let myRequest = URLRequest(url: myURL!)
		webViewHome.uiDelegate = self
		webViewHome.load(myRequest)
		webViewHome.navigationDelegate = self
		if #available(iOS 16.4, *) {
			webViewHome.isInspectable = true
		}
		
		self.changeInformationsBtn.setTitle(CommonFunctions.localisation(key: "CHANGE_INFORMATIONS"), for: .normal)
		
		self.changeInformationsBtn.backgroundColor = UIColor.blue_500
		self.changeInformationsBtn.layer.cornerRadius = self.changeInformationsBtn.frame.height / 2
		
		self.changeInformationsBtn.addTarget(self, action: #selector(changeInformationsBtnAct), for: .touchUpInside)
    }
}

extension KycWebVC {
	@objc func changeInformationsBtnAct(){
		let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		vc.isEditData = true
		self.navigationController?.pushViewController(vc, animated: false)
	}
	
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish URL: \(String(describing: webView.url))")
		
		if(webView.url?.absoluteString == "https://www.lyber.com/kyc-finished?action=OK&mode=SIGN&userAction=OK")
		{
			webViewHome = nil
			webViewRedirection = nil
			finishRegistration()
		}
    }
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if navigationAction.request.url != webView.url {
			if ((navigationAction.request.url?.absoluteString.hasPrefix("https://test.contralia.fr/Contralia")) == true && webView.url?.absoluteString.hasPrefix("https://preprod.id360docaposte.com/static/process_ui/index.html#/enrollment") == true){
				webViewHome.isHidden = false
				webViewRedirection.isHidden = true
				self.changeInformationsBtn.isHidden = true
				decisionHandler(.allow)
				return
			}
		}
		
		decisionHandler(.allow)
	}
	
	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		webViewRedirection = WKWebView(frame: view.bounds, configuration: configuration)
		webViewRedirection.uiDelegate = self
		webViewRedirection.navigationDelegate = self
		if #available(iOS 16.4, *) {
			webViewRedirection.isInspectable = true
		}
		webViewRedirection.load(navigationAction.request)
		webViewHome.isHidden = true
		view.addSubview(webViewRedirection)
		return webViewRedirection
		
	}
	
	func finishRegistration(){
		//end of register phase
		PersonalDataVM().finishRegistrationApi(controller: self ,completion: {[weak self]response in
			if response != nil {
				userData.shared.time = Date()
				GlobalVariables.isRegistering = false
				userData.shared.userToken = response?.data?.access_token ?? ""
				userData.shared.refreshToken = response?.data?.refresh_token ?? ""
				userData.shared.dataSave()
				CommonFunctions.loadingProfileApi()
				userData.shared.registered()
				let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
				self?.navigationController?.pushViewController(vc, animated: true)
			}
		})
	}
}


