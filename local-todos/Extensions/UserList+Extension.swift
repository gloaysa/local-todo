//
//  UserList+Extension.swift
//  local-todos
//
//  Created by Guillermo Loaysa on 21/1/24.
//

import Foundation
import UIKit
import SwiftUI

extension UserList {
	
	var uui: String {
		return self.objectID.uriRepresentation().absoluteString
	}
	
	
	private struct ColorData: Codable {
		var r: Double
		var g: Double
		var b: Double
		var a: Double
	}
	
	var color: Color {
		
		get {
			guard let data = colorData, let decoded = try? JSONDecoder().decode(ColorData.self, from: data) else { return Color.accentColor }
			
			return Color(.sRGB, red: decoded.r, green: decoded.g, blue: decoded.b, opacity: decoded.a)
		}
		
		set(newColor) {
			
#if os(iOS)
			let nativeColor = UIColor(newColor)
#elseif os(macOS)
			let nativeColor = NSColor(newColor)
#endif
			var (r, g, b, a) = (CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
			nativeColor.getRed(&r, green: &g, blue: &b, alpha: &a)
			if let encoded = try? JSONEncoder().encode(ColorData(r: Double(r), g: Double(g), b: Double(b), a: Double(a))) {
				colorData = encoded
			}
		}
	}
}
