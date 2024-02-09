//
//  KycWebVC.swift
//  Lyber
//
//  Created by sonam's Mac on 07/07/22.
//

import UIKit
import WebKit
import AppsFlyerLib

class KycWebVC: NotSwipeGesture,WKNavigationDelegate, UIScrollViewDelegate {
	
    //MARK: - Variables
    var kycUrl = String()
    var revalidation = false
    //MARK: - IB OUTLETS
    @IBOutlet var webViewHome: WKWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

	//MARK: - SetUpUI
    override func setUpUI(){
        sleep(UInt32(1))
        let myURL = URL(string: kycUrl)
        let myRequest = URLRequest(url: myURL!)
        
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webViewHome.configuration.userContentController.addUserScript(script)
		webViewHome.uiDelegate = self
		webViewHome.load(myRequest)
		webViewHome.navigationDelegate = self
		if #available(iOS 16.4, *) {
			webViewHome.isInspectable = true
		}
    }
}

//MARK: WKUIDelegate
extension KycWebVC: WKUIDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("didFinish URL: \(String(describing: webView.url))")
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if navigationAction.request.url != webView.url{
			if((navigationAction.request.url?.absoluteString.hasPrefix("https://lyber.com/kyc-finished")) == true)
			{
                if(self.revalidation){
                    self.goToPortfolioHome(showLoader: true, typeLoader: "kyc")
                }else{
                    kycFinished()
                }
			}else if(navigationAction.request.url?.absoluteString.hasPrefix("https://lyber.com/sign-finished")) == true{
                if((navigationAction.request.url?.absoluteString.hasPrefix("https://lyber.com/sign-finished?event=signing_complete")) == true){
					webViewHome = nil
                    self.goToPortfolioHome(showLoader: true, typeLoader: "signing")
					
				}else{
					webViewHome = nil
					self.goToPortfolioHome()
					CommonFunctions.toster(CommonFunctions.localisation(key: "SIGN_NOT_OK"))
				}
				
			}
		}
		decisionHandler(.allow)
	}
	
}

//MARK: Other functions
extension KycWebVC {
	private func finishRegistration(){
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
                self?.goToPortfolioHome(showLoader: true, typeLoader: "kyc")
                AppsFlyerLib.shared().logEvent(AFEventCompleteRegistration, withValues: [
                  AFEventParamRegistrationMethod: "Lyber", // Type of signup method
                ]);
			}
		})
	}
	
    private func goToPortfolioHome(showLoader: Bool = false, typeLoader: String = ""){
		let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		vc.hasToShowLoader = showLoader
        if(showLoader){
            vc.typeLoader = typeLoader
        }
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	private func kycFinished(){
		PersonalDataVM().personalDataApi(language: userData.shared.language.uppercased(), completion: {[weak self]response in
            if response != nil{
				self?.finishRegistration()
			}
		})
	}
}


