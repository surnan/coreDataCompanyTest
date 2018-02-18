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
    
    
    func createEmployee(employeeName: String, birthday: Date, company: Company) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)  as! Employee
        
        employee.setValue(employeeName, forKey: "name")
        employee.company = company
        
        let  employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
//        employeeInformation.setValue("456", forKey: "taxId")  //legal but two variables to maintain for future updates
        employeeInformation.taxId = "456" //preferred syntax.  So if coreData propery name changes, you see error on the code compile
        employeeInformation.birthday = birthday
        
        employee.employeeInformation = employeeInformation
        
        
        
        do {
            try context.save()
            return (employee, nil)
        } catch let err {
            print("Failed ot create employee: ", err)
            return (nil, err)
        }
    }
}
