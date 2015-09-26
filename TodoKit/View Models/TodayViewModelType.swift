//
//  TodayViewModelType.swift
//  AppExtensionsDemo
//
//  Created by Vesza Jozsef on 12/06/15.
//  Copyright (c) 2015 József Vesza. All rights reserved.
//

import UIKit
import ViewModelExtensions

public protocol TodoViewModelType: ViewModelType {
    
    func count() -> Int
    func toggleStatusForRow(row: Int)
    func dataForRow(row: Int) -> TodoCellDataType
}