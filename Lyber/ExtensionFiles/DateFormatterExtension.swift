//
//  DateFormatterExtension.swift
//  Lyber
//
//  Created by Lyber on 28/08/2023.
//

import Foundation

extension DateFormatter {
	func configureLocale() {
		if userData.shared.language == "fr" {
			self.locale = Locale(identifier: "fr_FR")
		} else {
			self.locale = Locale(identifier: "en_GB")
		}
	}
}
