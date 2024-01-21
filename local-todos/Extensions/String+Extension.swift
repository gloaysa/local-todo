//
//  String+Extension.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import Foundation

extension String {
    // extend String to add new function to check if name of the lis
    var isEmptyOrWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
