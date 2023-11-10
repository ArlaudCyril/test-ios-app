//
//  KycWebVC.swift
//  Lyber
//
//  Created by sonam's Mac on 07/07/22.
//

import UIKit
import WebKit
import AppsFlyerLib

class KycWebVC: NotSwipeGesture,WKNavigationDelegate {
	
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

//MARK: WKUIDelegate
extension KycWebVC: WKUIDelegate {
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
		if navigationAction.request.url != webView.url{
			if ((navigationAction.request.url?.absoluteString.hasPrefix(AppConfig.dictEnvVariables["CONTRALIA_URL"] as? String ?? "https://test.contralia.fr/Contralia")) == true && webView.url?.absoluteString.hasPrefix(AppConfig.dictEnvVariables["CONTRALIA_KYC_URL"] as? String ?? "https://preprod.id360docaposte.com/static/process_ui/index.html#/enrollment") == true){
				webViewHome.isHidden = false
				webViewRedirection.isHidden = true
				self.changeInformationsBtn.isHidden = true
				decisionHandler(.allow)
			}else if(navigationAction.request.url?.absoluteString.hasPrefix(AppConfig.dictEnvVariables["CONTRALIA_PSAN_CONTRACT_URL"] as? String ?? "https://test.contralia.fr/eDoc/user-api/document/coreDocument?coreDocUrl") == true){
				
				decisionHandler(.cancel)
				downloadFile(name: "contrat_psan", url: navigationAction.request.url!)
				
			}else{
				decisionHandler(.allow)
			}
		}else{
			decisionHandler(.allow)
		}
		
	}
	
	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		if(navigationAction.request.url?.absoluteString.hasPrefix("https://www.docaposte.com/wp-content/uploads/2023/09/politique_confidentialite") == true){
			downloadFile(name: "politique_confidentialite", url: navigationAction.request.url!)
			return nil
		}else if(navigationAction.request.url?.absoluteString.hasPrefix(AppConfig.dictEnvVariables["CONTRALIA_CGUID_URL"] as? String ?? "https://preprod.id360docaposte.com/static/process_ui/assets/pdf/cguid360") == true){
			
			downloadFile(name: "cguid360", url: navigationAction.request.url!)
			return nil
			
		}else if(navigationAction.request.url?.absoluteString.hasPrefix(AppConfig.dictEnvVariables["CONTRALIA_CONFIDENTIALITY_ID360"] as? String ?? "https://preprod.id360docaposte.com/static/process_ui/assets/pdf/politiqueconfidentialite") == true){
			
			downloadFile(name: "politique_confidentialite_id360", url: navigationAction.request.url!)
			return nil
			
		}else{
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
		
	}
	

	
}

//MARK: Other functions
extension KycWebVC {
	@objc func changeInformationsBtnAct(){
		let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		vc.isEditData = true
		self.navigationController?.pushViewController(vc, animated: false)
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
                AppsFlyerLib.shared().logEvent(AFEventCompleteRegistration, withValues: [
                  AFEventParamRegistrationMethod: "Lyber", // Type of signup method
                ]);
			}else{
				CommonFunctions.toster("KYC didn't work")
			}
		})
	}
	
	func downloadFile(name: String, url: URL){
		//Download
		let session = URLSession(configuration: .default)
		// Crée une tâche de téléchargement
		let downloadTask = session.downloadTask(with: url) { localURL, response, error in
			if let error = error {
				print("Erreur de téléchargement : \(error)")
				DispatchQueue.main.async {
					CommonFunctions.toster(CommonFunctions.localisation(key: "DOWNLOAD_ERROR"))
				}
			} else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
				if let localURL = localURL {
					do {
						let fileManager = FileManager.default
						let baseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
						
						var finalURL = baseURL.appendingPathComponent("\(name).pdf")
						
						var counter = 0
						
						while fileManager.fileExists(atPath: finalURL.path) {
							counter += 1
							// Construit le nouveau nom de fichier avec le compteur
							let newName = "\(name)(\(counter)).pdf"
							finalURL = baseURL.appendingPathComponent(newName)
						}
						
						try fileManager.moveItem(at: localURL, to: finalURL)
						DispatchQueue.main.async {
							CommonFunctions.toster(CommonFunctions.localisation(key: "DOWNLOAD_COMPLETED"))
						}
						print("Fichier téléchargé à : \(finalURL)")
						
					} catch {
						print("Erreur de déplacement du fichier : \(error)")
						DispatchQueue.main.async {
							CommonFunctions.toster(CommonFunctions.localisation(key: "DOWNLOAD_ERROR"))
						}
					}
				}
			}
		}
		// Lance la tâche de téléchargement
		downloadTask.resume()
	}
}


