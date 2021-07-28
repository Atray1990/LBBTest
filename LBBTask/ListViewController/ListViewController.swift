//
//  ListViewController.swift
//  NetMedsTask
//
//  Created by shashank atray on 11/09/20.
//  Copyright © 2020 shashank atray. All rights reserved.
//  LinkeIn - https://www.linkedin.com/in/shashank-k-atray/
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    // lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 10, y: 5, width: 250, height: 25))
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var saveButton:UIButton!
    
    let tableViewDataSource = TableViewDataSource()
    var eventHandler: ListViewEventHandler!
    
    var testPackage: [Articles] = []
    var searchText: String?
    var selectedTestPackage: [Articles] = []
    
    // MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      //  eventHandler.fetchChatdata()
        eventHandler.getCoreData()
        selectedTestPackage = []
        // deleting previously saved core data value
    }
    
    
    func setUpViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popBack))
        navigationItem.title = "Search News"
        self.tableView.dataSource = tableViewDataSource
        self.tableView.reloadData()
    }
    
    func showAlertForEmpty() {
        let alert = UIAlertController(title: "Title", message: "Please Select a test you want to be done.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    func showTestDataFromCore(testData:[Articles]) {
        self.tableViewDataSource.testData = testData
        eventHandler.fetchChatdata()
        DispatchQueue.main.async {
            self.eventHandler.saveDataToCoreData(testData: testData)
            self.tableView.reloadData()
        }
    }
    
    func saveTestData(testData: TestPackage) {
        if let articles = testData.articles {
            self.testPackage = articles
        }
    }
    
    func showTestData(testData: TestPackage) {
        if let articles = testData.articles {
            self.tableViewDataSource.testData = articles
            DispatchQueue.main.async {
                self.eventHandler.saveDataToCoreData(testData: articles)
                self.tableView.reloadData()
            }
            
        }
       
    }
    
    // MARK:- iboutlet and navigation
    /* not that proficient with Core Data, havnt used in long time hence added another way to manage the data as well.
     */
    @IBAction func submitThroughCoreData() {
        if selectedTestPackage.isEmpty {
            showAlertForEmpty()
        }
    }
    
    @objc func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonClicked() {
        if selectedTestPackage.isEmpty {
            showAlertForEmpty()
        }
    }
    
}

