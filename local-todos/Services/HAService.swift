//
//  HAService.swift
//  local-todos
//
//  Created by Guillermo Loaysa on 24/1/24.
//

import Foundation
import HAKit
import SwiftUI

struct HATodos: Identifiable {
	let id: String
	let totalNumber: Int
	let friendlyName: String
}

class HAService {
	
	private var connection: HAConnection?
	
	init() {
		
		connection = HAKit.connection(configuration: .init(
			connectionInfo: {
				print("[HAService]: Establishing connection to HA")
				// Connection is required to be returned synchronously.
				// In a real implementation, handle both URL/connection info without crashing.
				return try! .init(url: URL(string: "http://homeassistant.local:8123")!)
			},
			fetchAuthToken: { completion in
				// Access tokens are retrieved asynchronously, but be aware that Home Assistant
				// has a timeout of 10 seconds for sending your access token.
				completion(.success("token"))
			}
		))
	}
	
	func subscribeToTodos() -> Void {
		connection?.subscribe(
			to: .subscribeEntities(["entity_ids": ["todo.guille"]]),
			initiated: { result in
				print("initial result", result)
			},
			handler: {cancel, data in
				print("subscribe result", data)
			}
		)
	}
	
	func retrieveLists() -> Void {
		print("getting lists...")
		connection?.send(.init(
			type: .rest(.get, "states")
		)) { result in
			switch result {
			case let .success(data):
				switch data {
				case .array(let dataArray):
					let todoEntities = dataArray.compactMap { (data) -> [String: Any]? in
						guard case .dictionary(let dictionaryData) = data,
									let entityID = dictionaryData["entity_id"] as? String,
									entityID.hasPrefix("todo") else {
							return nil
						}
						return dictionaryData
					}
					
					let entities: [HATodos] = todoEntities.compactMap { entity in
						let entityId = entity["entity_id"] as! String
						let state = Int(entity["state"] as! String)
						var friendly_name: String?
						
						if let attributes = entity["attributes"] as? [String: Any] {
							if let friendlyName = attributes["friendly_name"] as? String {
								// Use friendlyName here
								friendly_name = friendlyName
							}
						}
						// let friendlyName = attributes["friendly_name"] as? String
						// let attributes = HATodos.Attributes(friendly_name: friendlyName)
						return HATodos(id: entityId, totalNumber: state ?? 0, friendlyName: friendly_name!)
						
					}
					
					let lists: [UserList] = entities.compactMap { list in
						do {
							return try UserListService.createUserList(name: list.friendlyName, color: Color(.blue), entityId: list.id)
						} catch {
							print(error)
							return nil
						}
					}
					
				case .dictionary(let dictionaryData):
					// Handle dictionary response
					// print("Received dictionary data:", dictionaryData)
					// Example: Accessing a specific key
					print("is dictionary")
					
				case .empty:
					// Handle empty response
					print("Received empty response")
				case .primitive(let primitiveData):
					// Handle primitive response
					print("Received primitive data:")
				}
			case let .failure(error):
				print(error)
			}
		}
	}

}
