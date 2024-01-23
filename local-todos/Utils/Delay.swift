//
//  Delay.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import Foundation

class Delay {
	private var seconds: Double
	var workItem: DispatchWorkItem?
	
	init(seconds: Double = 2.0) {
		self.seconds = seconds
	}
	
	func delay(_ callback: @escaping () -> Void) {
		workItem = DispatchWorkItem(block: {
			callback()
		})
		
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem!)
	}
	
	func cancel() {
		workItem?.cancel()
	}
}
