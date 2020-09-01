//
//  Swinject+Storyboard.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        
        let appContainer = AppContainer.shared.container
        
        defaultContainer.storyboardInitCompleted(OrderOutViewController.self) { _, controller in
            controller.viewModel = appContainer.resolve(OrderOutViewModel.self)
        }
    }
}
