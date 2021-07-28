//
//  ListNavigationFactory.swift
//  NetMedsTask
//
//  Created by shashank atray on 12/09/20.
//  Copyright © 2020 shashank atray. All rights reserved.
//  LinkeIn - https://www.linkedin.com/in/shashank-k-atray/
//

/*
    Factory class to create new classes navigational value from here, same can be done for cart screen but didnt have much to navigate there.
 */

import Foundation
import UIKit

public protocol ListNavigatable {
    func makeListViewController(from navController: UINavigationController)
}

extension ListNavigatable { 
    public func makeListViewController(from navController: UINavigationController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        let requestHandler = GetDataRequestHandler()
        let navigator = ListNavigatorRouting()
        let eventHandler = ListViewEventHandler.init(viewController: viewController, requestHandler: requestHandler, navigator: navigator)
        viewController.eventHandler = eventHandler
        navController.pushViewController(viewController, animated: true)
    }
    

}

open class ListNavigatorRouting: ListNavigatable {
    public init() {
    }
}
