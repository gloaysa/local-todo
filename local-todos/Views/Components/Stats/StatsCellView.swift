//
//  ReminderStatsView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 19/1/24.
//

import SwiftUI

struct StatsCellView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let icon: String
    let title: String
    let count: Int?
    let iconColor: Color
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.title)
                    Text(title)
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                if let count {
                    Text("\(count)")
                        .font(.largeTitle)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.darkGray : .offWhite)
        .foregroundColor(colorScheme == .dark ? Color.offWhite : .darkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
    }
}

#Preview {
    StatsCellView(
        icon: "calendar",
        title: "Today",
        count: 9,
        iconColor: .blue
    )
}
