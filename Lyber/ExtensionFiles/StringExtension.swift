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
	
	var encoderNetwork: String {
		switch self {
			case "eth":
				return "ethereum"
			case "sol":
				return "solana"
			default:
				return self
		}
	}
	
	var decoderSecurityTime: String{
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
    
}
