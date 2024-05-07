//
//  ViewControllerExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import Foundation
import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && AppConfig.dictEnvVariables["ENV"] as? String == "STAGING"{
            sendLogsByEmail()
        }
    }
    
    func logMessage(_ message: String) {
        print(message)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        let logMessage = "\(timestamp): \(message)\n"

        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let logFileURL = documentDirectory.appendingPathComponent("appLogs.txt")
            
            // Check if file exists
            if FileManager.default.fileExists(atPath: logFileURL.path) {
                // Append to existing file
                if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                    fileHandle.seekToEndOfFile()
                    if let data = logMessage.data(using: .utf8) {
                        fileHandle.write(data)
                    }
                    fileHandle.closeFile()
                }
            } else {
                // Create new file
                try? logMessage.write(to: logFileURL, atomically: true, encoding: .utf8)
            }
        }
    }

    func sendLogsByEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["elie@lyber.com"])
            mail.setSubject("App Logs")
            
            if let logData = retrieveLogs() {
                mail.addAttachmentData(logData, mimeType: "text/plain", fileName: "logs.txt")
            }
            
            present(mail, animated: true)
        } else {
            print("Cannot send mail")
        }
    }
    
    func retrieveLogs() -> Data? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let logFileURL = documentDirectory.appendingPathComponent("appLogs.txt")
        
        do {
            let logData = try Data(contentsOf: logFileURL)
            return logData
        } catch {
            print("Error reading log file: \(error)")
            return nil
        }
    }
    
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = false) -> Bool{
	  
	  if let vc = viewControllers.first(where: { $0.isKind(of: ofClass) }) {
		  popToViewController(vc, animated: animated)
          return true
	  }
      return false
  }
	
	func popToPortfolioHomeOrPortfolioDetail(animated: Bool = false) {
		  
		if let vc = viewControllers.last(where: { $0.isKind(of: PortfolioHomeVC.self) || $0.isKind(of: PortfolioDetailVC.self) }) {
			  popToViewController(vc, animated: animated)
		  }
	  }
	
	func deleteToPortfolioHomeOrPortfolioDetail(animated: Bool = false) {
		for i in (1...viewControllers.count-2).reversed() {
			print(type(of: viewControllers[i]))
			if(viewControllers[i].isKind(of: PortfolioHomeVC.self) || viewControllers[i].isKind(of: PortfolioDetailVC.self)){
				return
			}else{
				viewControllers.remove(at: i)
			}
		}
	  }
	
	func popToPortfolioHomeOrAllAsset(animated: Bool = false) {
		  
		if let vc = viewControllers.last(where: { $0.isKind(of: PortfolioHomeVC.self) || ($0 as? AllAssetsVC)?.screenType == .portfolio }) {
			// Pop to the found view controller
			popToViewController(vc, animated: animated)
			return
		}
		let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
			pushViewController(vc, animated: false)
		
	  }
	
	func deleteToPortfolioHomeOrAllAsset(animated: Bool = false) {
		for i in (1...viewControllers.count-2).reversed() {
			print(type(of: viewControllers[i]))
			if(viewControllers[i].isKind(of: PortfolioHomeVC.self) || (viewControllers[i] as? AllAssetsVC)?.screenType == .portfolio){
				return
			}else{
				viewControllers.remove(at: i)
			}
		}
	  }
	
	
	func deleteToViewController(ofClass: AnyClass) {
		if(ofClass == AllAssetsVC.self){
			for i in (1...viewControllers.count-2).reversed() {
				if(viewControllers[i].isKind(of: AllAssetsVC.self)){
					let allAssetController = viewControllers[i] as! AllAssetsVC
					if(allAssetController.screenType == .portfolio){
						return
					}
				}
				viewControllers.remove(at: i)
			}
		}else{
			for i in (1...viewControllers.count-2).reversed() {
				print(type(of: viewControllers[i]))
				if(viewControllers[i].isKind(of: ofClass)){
					return
				}else{
					viewControllers.remove(at: i)
				}
			}
		}
	}
}
