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
}
