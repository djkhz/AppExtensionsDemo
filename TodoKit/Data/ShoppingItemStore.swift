//
//  ShoppingItemStore.swift
//  AppExtensionsDemo
//
//  Created by Vesza Jozsef on 11/06/15.
//  Copyright (c) 2015 József Vesza. All rights reserved.
//

import Foundation

/// Key to use when saving the data to `NSUSerDefaults`.
private let savedDataKey = "savedItems"
/// Notification to send when the host app needs to update its data.
let updateDataNotification = "updateData"

/// Default implementation of `ShoppingStoreType`, which interacts with `NSUserDefaults`.
public class ShoppingItemStore: NSObject, ShoppingStoreType {

    // MARK: - Properties and initialization
    
    private let defaults: NSUserDefaults?
    private let sessionManager: SessionManagerType?
    
    ///
    /// Initialize a `ShoppingItemStore` instance with a given app group identifier, and connectivity session manager.
    ///
    /// - parameter appGroupId: The app group identifier to use for shared sandbox (defaults to `nil`).
    /// - parameter sessionManager: A connectivity session manager instance to use for handling application context payloads (defaults to `nil`)
    ///
    public init(appGroupId: String? = nil, sessionManager: SessionManagerType? = nil) {
        defaults = NSUserDefaults(suiteName: appGroupId)
        self.sessionManager = sessionManager
        super.init()
        self.sessionManager?.store = self
    }
    
    // MARK: - ShoppingStoreType methods
    
    public func items() -> [ShoppingItem] {
        
        if let loaded = loadItems() {
            return loaded
        }
        
        return []
    }
    
    public func toggleItem(item: ShoppingItem) {
        
        let initial = items()
        
        let updated = initial.map { original -> ShoppingItem in
            return original == item ?
                ShoppingItem(name: original.name, status: !original.status) : original
        }
        
        saveItems(updated)
    }
    
    public func addNewItemWithTitle(title: String) {
        
        let initial = items()
        let newItem = ShoppingItem(name: title)
        
        let updated = initial + [newItem]
        
        saveItems(updated)
    }
    
    public func handleApplicationContextPayload(payload: [String : AnyObject]) {
        
        print(payload)
        
        guard let items = payload["items"] as? [[String : Bool]] else {
            print("Malformed payload data", "\(payload)")
            return
        }
        
        defaults?.setValue(items, forKey: savedDataKey)
        defaults?.synchronize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(updateDataNotification, object: nil)
    }
    
    public func clearAllDone() {
        let todoItems = items().filter { $0.status == false }
        saveItems(todoItems)
    }
    
    // MARK: - Private helper methods
    
    private func saveItems(items: [ShoppingItem]) {
        
        let boxedItems = items.map { item -> [String : Bool] in
            return [item.name : item.status]
        }
        
        defaults?.setValue(boxedItems, forKey: savedDataKey)
        defaults?.synchronize()
        
        let items = ["items" : boxedItems]
        
        do {
            try sessionManager?.updateApplicationContext(items)
        } catch {
            print("Oops")
        }
    }
    
    private func loadItems() -> [ShoppingItem]? {
        
        if let loaded = defaults?.valueForKey(savedDataKey) as? [[String : Bool]] {
            
            let unboxed = loaded.map { dict -> ShoppingItem in
                
                return ShoppingItem(name: dict.keys.first!, status: dict.values.first!)
            }
            
            return unboxed
        }
        
        return nil
    }
}