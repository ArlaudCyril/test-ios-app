//
//  Lanceur.swift
//  Lyber
//
//  Created by Lyber on 26/04/2023.
//

import UIKit

class Launcher: CAEmitterLayer {
	
	override init(layer: Any) {
		super.init(layer: layer)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setup(frame: CGRect) {
		emitterPosition = CGPoint(x: frame.width / 2, y: -10)
		emitterShape = CAEmitterLayerEmitterShape.line
		emitterSize = CGSize(width: frame.width, height: 2)
	}
	
	func runCells() {
		//CAEmitterCell
		emitterCells = createCells()
	}
	
	func createCells() -> [Confetti] {
		var confettis = [Confetti]()
		for _ in (0...30) {
			confettis.append(Confetti())
		}
		return confettis
	}
	
}
