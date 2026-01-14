//
//  ShoppingServiceProtocol.swift
//  Cooki
//
//  Created by Neth Botheju on 10/1/2026.
//
import Foundation

protocol ShoppingServiceProtocol {
    func fetchItems() async throws -> [Item]
    func addItem(_ item: Item) async throws -> Item
    func updateItem(_ item: Item) async throws -> Item
    func deleteItem(_ itemId: String) async throws
    func deleteMultipleItems(_ itemIds: [String]) async throws
}
