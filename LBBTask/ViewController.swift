//
//  ViewController.swift
//  LLBTask
//
//  Created by shashank atray on 18/08/21.
//  Copyright © 2020 shashank atray. All rights reserved.
//  LinkeIn - https://www.linkedin.com/in/shashank-k-atray/
//

import UIKit

class ViewController: UIViewController {
    
    let navigator = ListNavigatorRouting()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func goToListView() {
        if let navController = self.navigationController {
            navigator.makeListViewController(from: navController)
        }
    }
    
}

