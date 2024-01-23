//
//  TodoItem+Extension.swift
//  local-todos
//
//  Created by Guillermo Loaysa on 21/1/24.
//

import Foundation

extension TodoItem {
	
	var uui: String {
		return self.objectID.uriRepresentation().absoluteString
	}
	
}
