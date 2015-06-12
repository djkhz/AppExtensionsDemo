//
//  TodoViewModel.swift
//  AppExtensionsDemo
//
//  Created by Vesza Jozsef on 11/06/15.
//  Copyright (c) 2015 József Vesza. All rights reserved.
//

import UIKit
import TodoKit

struct TodoViewModel: TodayViewModelType {
    
    let store: ShoppingItemStore
    
    init(store: ShoppingItemStore = ShoppingItemStore.sharedInstance) {
        self.store = store
    }
    
    func count() -> Int {
        return store.items.count
    }
    
    func titleForRow(row: Int) -> String {
        return store.items[row].name
    }
    
    func statusForRow(row: Int) -> Bool {
        return store.items[row].status
    }
    
    func toggleStatusForRow(row: Int) {
        store.toggleAtIndex(row)
    }
}