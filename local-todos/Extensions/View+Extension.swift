//
//  View+Extension.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 20/1/24.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
