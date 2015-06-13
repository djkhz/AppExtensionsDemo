//
//  ShoppingItemStore.swift
//  AppExtensionsDemo
//
//  Created by Vesza Jozsef on 11/06/15.
//  Copyright (c) 2015 József Vesza. All rights reserved.
//

import UIKit

private let appGroupId = "group.hu.jozsefvesza.appextensionsdemo"
private let savedDataKey = "savedItems"

public class ShoppingItemStore: ItemStoreType {
    
    public static let sharedInstance = ShoppingItemStore()
    public private(set) var items = [ShoppingItem]() {
        didSet {
            storeItemState(items)
        }
    }
    
    private let defaultItems = [
        ShoppingItem(name: "Coffee"),
        ShoppingItem(name: "Banana"),
    ]
    
    private let defaults = NSUserDefaults(suiteName: appGroupId)
    
    public init() {
        if let savedItems = loadItems() {
            items = savedItems
        } else {
            items = defaultItems
        }
    }
    
    public func toggle(item: ShoppingItem) {
        
        items = items.map { original -> ShoppingItem in
            
            return original == item ?
                ShoppingItem(name: original.name, status: !original.status) : original
        }
    }
}

extension ShoppingItemStore: ItemPersisterType {
    
    internal func storeItemState(items: [ShoppingItem]) {
        
        let boxedItems = items.map { item -> [String : Bool] in
            return [item.name : item.status]
        }
        
        defaults?.setValue(boxedItems, forKey: savedDataKey)
        defaults?.synchronize()
    }
    
    internal func loadItems() -> [ShoppingItem]? {
        
        if let loaded = defaults?.valueForKey(savedDataKey) as? [[String : Bool]] {

            let unboxed = loaded.map { dict -> ShoppingItem in
                
                return ShoppingItem(name: dict.keys.first!, status: dict.values.first!)
            }
            
            return unboxed
        }
        
        return nil
    }
}