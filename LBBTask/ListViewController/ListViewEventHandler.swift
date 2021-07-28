//
//  ListViewEventHandler.swift
//  LLBTask
//
//  Created by shashank atray on 18/08/21.
//  Copyright © 2020 shashank atray. All rights reserved.
//  LinkeIn - https://www.linkedin.com/in/shashank-k-atray/
//

import Foundation
import UIKit
import CoreData

open class ListViewEventHandler {
    
    weak var viewController: ListViewController?
    let navigator: ListNavigatorRouting
    let requestHandler: GetDataRequestHandler
    
    init(viewController: ListViewController, requestHandler: GetDataRequestHandler, navigator: ListNavigatorRouting) {
        self.viewController = viewController
        self.requestHandler = requestHandler
        self.navigator = navigator
    }
    
    func getCoreData() {
        requestHandler.coreDataFetch{ result in   // call to request handle to return the data
            
            if !(result.isEmpty) {
                let testData = self.handleDataFromCoreData(testData:result )
                self.viewController?.showTestDataFromCore(testData:testData )
            } else {
                self.fetchChatdata()
            }
        }
    }
    
    func fetchChatdata() {
        let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2021-06-28&sortBy=publishedAt&apiKey=b8121222a7e5413caafa4421c8f84156")!
        requestHandler.requestForUserDataWith(requestUrl: url) { result in
            if let result = result as? TestPackage {
                self.viewController?.showTestData(testData: result)
                self.viewController?.saveTestData(testData: result)
            }
        }
    }
    
    func deleteAllCoreDataValues() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TestData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch {
            print ("There was an error")
        }
    }
    
    func saveDataToCoreData(testData: [Articles]) {
        guard testData.count > 0 else {
            return
        }
        deleteAllCoreDataValues()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TestData", in: context)

        for index in 0...testData.count - 1 {
            let managedObject = NSManagedObject(entity: entity!, insertInto: context)
            managedObject.setValue(testData[index].author, forKey: "author")
            managedObject.setValue(testData[index].title, forKey: "title")
            managedObject.setValue(testData[index].description, forKey: "desc")
            managedObject.setValue(testData[index].url, forKey: "url")
            managedObject.setValue(testData[index].urlToImage, forKey: "urlToImage")
            managedObject.setValue(testData[index].publishedAt, forKey: "publishedAt")
            managedObject.setValue(testData[index].content, forKey: "content")
            do {
                try context.save()
            } catch {
                print("didnt save")
            }
           
        }
    }
    
    func handleDataFromCoreData(testData: [NSManagedObject]) -> [Articles] {
        // binding core data to pre-exiting modal and reusing the modal
        let testPackage: [Articles] = testData.map { testDataDict in
            
            let author = testDataDict.value(forKey: "author") as? String ?? ""
            let title = testDataDict.value(forKey: "title") as? String ?? ""
            let desc = testDataDict.value(forKey: "desc") as? String ?? ""
            let url = testDataDict.value(forKey: "url") as? String ?? ""
            let urlToImage = testDataDict.value(forKey: "urlToImage") as? String ?? ""
            let publishedAt = testDataDict.value(forKey: "publishedAt") as? String ?? ""
            let content = testDataDict.value(forKey: "content") as? String ?? ""
            
            let testPackage = Articles(source: nil, author: author, title: title, description: desc, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
            return testPackage
        }
        return testPackage
    }
    

}
