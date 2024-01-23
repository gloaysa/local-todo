//
//  Color+Extension.swift
//  local-todos
//
//  Created by Guillermo Loaysa on 20/1/24.
//

import Foundation
import SwiftUI

extension Color {
    
    static let darkGray = Color(red: 27/255, green: 27/255, blue: 30/255)
    static let offWhite = Color(red: 242/255, green: 242/255, blue: 246/255)
	
	private struct ColorData: Codable {
		var r: Double
		var g: Double
		var b: Double
		var a: Double
	}
	
	static func decodeColor(from data: Data?) -> Color {
		guard let data = data, let decoded = try? JSONDecoder().decode(ColorData.self, from: data) else { return Color.accentColor }
		
		return Color(.sRGB, red: decoded.r, green: decoded.g, blue: decoded.b, opacity: decoded.a)
	}
	
	static func encodeColor(_ color: Color) -> Data? {
		#if os(iOS)
		let nativeColor = UIColor(color)
		#elseif os(macOS)
		let nativeColor = NSColor(color)
		#endif
		var (r, g, b, a) = (CGFloat.zero, CGFloat.zero, CGFloat.zero, CGFloat.zero)
		nativeColor.getRed(&r, green: &g, blue: &b, alpha: &a)
		
		return try? JSONEncoder().encode(ColorData(r: Double(r), g: Double(g), b: Double(b), a: Double(a)))
	}

    
}
