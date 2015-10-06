//
//  GlanceInterfaceController.swift
//  AppExtensionsDemo
//
//  Created by József Vesza on 07/10/15.
//  Copyright © 2015 József Vesza. All rights reserved.
//

import WatchKit
import Foundation


class GlanceInterfaceController: WKInterfaceController {

    @IBOutlet private weak var countLabel: WKInterfaceLabel!
    
    let viewModel = GlanceViewModel()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        countLabel.setText(viewModel.titleForStatusLabel)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
