//
//  CompaniesController.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    
    @objc func doWork() {
        print("doing Work....")
        
        //GCD - Grand Central Dispatch
        
        //Preferred way to do background tasks with CoreData with line below
        //With the line below, we don't need to use DispatchQueue methods
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...20000).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            do {
                try backgroundContext.save() //if you execute save too many times, you will crash.
            } catch let err {       //so this should be outside the .forEach loop above
                print("Failed to save: ", err)
            }
        })
        
       /*
        DispatchQueue.global(qos: .background).async {
            
            //Preferred way to do background tasks with CoreData with line below
            CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
                (0...20000).forEach { (value) in
                    print(value)
                    let company = Company(context: backgroundContext)
                    company.name = String(value)
                }
                do {
                    try backgroundContext.save() //if you execute save too many times, you will crash.
                } catch let err {       //so this should be outside the .forEach loop above
                    print("Failed to save: ", err)
                }
            })
         
            
            
//            let context = CoreDataManager.shared.persistentContainer.viewContext  //risky because NSManagedContext should be main Q
            //            let company = Company(context: context) //Company class is auto-generated from our CoreData Schema
            /*
             @objc(Company)
             public class Company: NSManagedObject {}
             */
            
//            (0...10).forEach { (value) in
//                print(value)
//                let company = Company(context: context)
//                company.name = String(value)
//            }
//            do {
//                try context.save() //if you execute save too many times, you will crash.
//            } catch let err {       //so this should be outside the .forEach loop above
//                print("Failed to save: ", err)
//            }
            
        }
    */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.companies = CoreDataManager.shared.fetchCompanies()  //normally, you should reload tableView when fetching companies
        //however, tableview auto-reloads at the end of ViewDidLoad() auto
        //lifecyle of uitableview
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(doWork))
        ]
        
        
        
        view.backgroundColor = .white
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus") .withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        
        
        navigationItem.title = "Companies"
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()  // footer = blank, won't get mulitple separator lines after final row
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")  //for default UITableView Cells
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellID")  //with this line alone (nothing changes)
    }
    
    @objc private func handleReset(){
        print("Attempting to delete all core data objects")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        //         It works but you can't do any animation with it.
        //         companies.forEach { (company) in
        //         context.delete(company)
        //         }
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            var indexPathsToRemove = [IndexPath]()
            //companies.forEach() //doesn't return the row # //"companies.index(of:" -> you need to unwrap optional
            for (index, _ ) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .fade)
            //            companies.removeAll()  //<-- remove all entries from arry
            //            tableView.reloadData()
        } catch let delErr{
            print("Failed to delete objects from Core Data: ", delErr)
        }
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navController, animated: true, completion: nil)
    }
}
