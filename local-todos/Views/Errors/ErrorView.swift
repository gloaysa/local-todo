//
//  NavigationViewError.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 20/1/24.
//

import SwiftUI

struct NavigationViewError: View {
    @Environment(\.dismiss) private var dismiss
    
    var errorMessage: String
    
    var body: some View {
        NavigationStack {
            HStack {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Error")
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            
        }
        
    }
}

#Preview {
    NavigationViewError(errorMessage: "some error")
}
