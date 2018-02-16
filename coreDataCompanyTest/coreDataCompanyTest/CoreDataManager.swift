//
//  CoreDataManager.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import CoreData


/*
 SINGLETONS (and their values) -- Live for the entire life of the application
 */
struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateTrainingModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed:\(err)")
            }
        }
        return container
    }()
    
    
    func fetchCompanies() -> [Company]{
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
//            self.companies = companies    <--- error
//            self.tableView.reloadData()   <--- error
        } catch let fetchErr {
            print("Failed to fetch companies: ", fetchErr)
            return []
        }
    }
}
