//
//  ColorPickerView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 17/1/24.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var selectedColor: Color
    
    let colors: [Color] = [
        .orange,
        .yellow,
        .green,
        .mint,
        .teal,
        .cyan,
        .blue,
        .purple,
        .pink,
        .brown,
        .gray,
    ]
    
    /// Compares two UIColor objects for equality with a specified tolerance.
    ///
    /// - Parameters:
    ///   - color1: The first UIColor to compare.
    ///   - color2: The second UIColor to compare.
    ///   - tolerance: The allowable difference between color components. The default value is 0.01.
    ///
    /// - Returns: `true` if the colors are considered equal within the specified tolerance; otherwise, `false`.
    func compareColors(_ color1: UIColor, _ color2: UIColor, tolerance: CGFloat = 0.01) -> Bool {
        // Extract the components (red, green, blue, alpha) from color1
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        
        // Extract the components (red, green, blue, alpha) from color2
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // Check if the components of the colors are within the specified tolerance
        let redEqual = abs(r1 - r2) < tolerance
        let greenEqual = abs(g1 - g2) < tolerance
        let blueEqual = abs(b1 - b2) < tolerance
        let alphaEqual = abs(a1 - a2) < tolerance
        
        // Return true if all components are equal within the specified tolerance, otherwise return false
        return redEqual && greenEqual && blueEqual && alphaEqual
    }

    
    private func selectedColorIsTheSame(_ color: Color) -> Bool {
        return compareColors(UIColor(selectedColor), UIColor(color))
    }
    
    var body: some View {
        GeometryReader { geometry in
            let columns = Array(
                repeating: GridItem(
                    .fixed(50),
                    spacing: 8
                ),
                count: calculateColumns(width: geometry.size.width)
            )
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(colors, id: \.self) { color in
                    ZStack {
                        Circle().fill()
                            .foregroundColor(color)
                            .padding(2)
                        Circle()
                            .strokeBorder(selectedColorIsTheSame(color) ? .gray : .clear, lineWidth: 4)
                            .scaleEffect(CGSize(width: 1.2, height: 1.2))
                    }
                    .onTapGesture {
                        selectedColor = color
                    }
                }
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
    
    private func calculateColumns(width: CGFloat) -> Int {
        let minColumnWidth: CGFloat = 60
        let availableWidth = width - 16 // Adjust for padding and spacing
        let columns = Int(availableWidth / minColumnWidth)
        return max(1, columns)
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant(.yellow))
}
