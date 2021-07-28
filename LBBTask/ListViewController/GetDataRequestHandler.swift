//
//  GetDataRequestHandler.swift
//  NetMedsTask
//
//  Created by shashank atray on 11/09/20.
//  Copyright © 2020 shashank atray. All rights reserved.
//  LinkeIn - https://www.linkedin.com/in/shashank-k-atray/
//

import Foundation
import CoreData
import UIKit

public protocol GetDataRequestHandlerUseCase {
    func requestForUserDataWith(requestUrl: URL, completionHandler: @escaping(_ result: TestPackage?) -> ())
    func coreDataFetch(completionHandler: @escaping(_ result: [NSManagedObject]) -> ())
}

extension GetDataRequestHandlerUseCase {
    
    public func requestForUserDataWith(requestUrl: URL, completionHandler: @escaping(_ result: TestPackage?) -> ()) {
        
        let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
           do {
                let testPackage = try? JSONDecoder().decode(TestPackage.self, from: data)
                completionHandler(testPackage ?? nil)
                
            } catch {
                print("can not wrap json", error)
            }
        }
        task.resume()
    }
    
    public func coreDataFetch(completionHandler: @escaping(_ result: [NSManagedObject]) -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TestData")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            if let data = result as? [NSManagedObject] {
                completionHandler(data)
            }
            
        } catch {
            print("Failed")
        }
    }
}

public struct GetDataRequestHandler: GetDataRequestHandlerUseCase {
    public init() {}
}
