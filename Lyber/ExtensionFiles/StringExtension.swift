//
//  StringExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 02/06/22.
//

import Foundation
extension String{
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
   

      func isValidHexNumber() -> Bool {
          let chars = NSCharacterSet(charactersIn: "0123456789abcdefxABCDEFX").inverted
          let filtered: String = (self.components(separatedBy: chars as CharacterSet) as NSArray).componentsJoined(by: "")
          if self == filtered{
              return true
          }else{
              return false
          }
      }
    
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }
	
	var decoderNetwork: String {
		switch self {
			case "ethereum":
				return "eth"
			case "solana":
				return "sol"
			default:
				return self
		}
	}
	var decoderStatusDeposit: String {
		switch self {
			case "PENDING":
				return CommonFunctions.localisation(key: "IN_PROGRESS")
			case "BLOCKED":
				return CommonFunctions.localisation(key: "UNDER_CONFORMITY_ANALYSIS")
			case "CREDITED":
				return CommonFunctions.localisation(key: "CREDITED")
			default:
				return self
		}
	}
	
	
	var decoderStatusWithdraw: String {
		switch self {
			case "PENDING":
				return CommonFunctions.localisation(key: "PENDING")
			case "VALIDATE":
				return CommonFunctions.localisation(key: "SENT")
			case "CANCELED":
				return CommonFunctions.localisation(key: "CANCELED")
			default:
				return self
		}
	}
	
	var decoderStatusOrder: String {//Status : 
		switch self {
			case "PENDING":
				return CommonFunctions.localisation(key: "PENDING")
			case "PROCESSED":
				return CommonFunctions.localisation(key: "PROCESSED")
			case "VALIDATED":
				return CommonFunctions.localisation(key: "VALIDATED")
			case "FAILED_SEND":
				return CommonFunctions.localisation(key: "FAILED_SEND")
			case "CANCELED":
				return CommonFunctions.localisation(key: "CANCELED")
			default:
				return self
		}
	}
	
	var encoderAnnualIncome: String{
		switch self {
			case "Less than 500€/month":
				return "<500"
			case "500-1000€/month":
				return "500-1000"
			case "1001-1500€/month":
				return "1001-1500"
			case "1501-2000€/month":
				return "1501-2000"
			case "2001-3000€/month":
				return "2001-3000"
			case "Over 3001€/month":
				return "3001+"
			default:
				return self
		}
	}
	
	var encoderSecurityTime: String{
		switch self {
			case "72_HOURS":
				return "3d"
			case "24_HOURS":
				return "1d"
			case "NO_EXTRA_SECURITY":
				return "none"
			default:
				return self
		}
	}
	
	var decoderSecurityTime: String{
		switch self {
			case "3d":
				return "72_HOURS"
			case "1d":
				return "24_HOURS"
			case "none":
				return "NO_EXTRA_SECURITY"
			default:
				return self
		}
	}
	
	var addressFormat: String{
		if(self.count > 14){
			return self.prefix(8) + "..." + self.suffix(6)
		}
		return self
	}
	
	var phoneFormat: String{
		var phone = self
		if phone.first == "0" {
			phone.removeFirst()
		}
		return phone
	}
    
    var euroFormat: String? {
        if let doubleValue = Double(self) {
            let roundedValue = String(format: "%.2f", doubleValue)
            return roundedValue
        }
        
        return nil
    }
    
    var decoderKycStatus: VerificationIndicator {
        switch self {
        case "OK":
            return .validated
        case "REVIEW":
            return .pending
        case "CANCELED", "FAILED":
            return .rejected
        case "NOT_STARTED", "STARTED":
            return .notPerformed
        case "LYBER_REFUSED":
            return .ban
        default:
            return .notPerformed
        }
    }
    
    var decoderSigningStatus: VerificationIndicator {
        switch self {
        case "SIGNED":
            return .validated
        case "NOT_SIGNED":
            return .notPerformed
        default:
            return .notPerformed
        }
    }
    
    var decoderSigningStatusBool: Bool {
        switch self {
        case "SIGNED":
            return true
        case "NOT_SIGNED":
            return false
        default:
            return false
        }
    }
}
