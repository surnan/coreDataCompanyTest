//
//  CompaniesController.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/8/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
//        let newCompany = Company(name: company.name, founded: Date())
//        companies.append(newCompany)
//
//
//        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    

    
    
    var companies = [Company]()
    
//    var companies = [
//                Company(name: "Apple", founded: Date()),
//                Company(name: "Google", founded: Date()),
//                Company(name: "Facebook", founded: Date())
//    ]
    
    func addCompany(company: Company) {
//        let newCompany = Company(name: company.name, founded: Date())
//        companies.append(newCompany)
//        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    private func fetchCompanies(){
        let persistentContainer = NSPersistentContainer(name: "IntermediateTrainingModel")
        persistentContainer.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed:\(err)")
            }
        }
        
        //When you "insertObject", you're not saving.  You're only putting it into a context so it can be saved later on
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach({ (company) in
                print(company.name ?? "")
            })
        } catch let fetchErr {
            print("Failed to fetch companies: ", fetchErr)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
       view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus") .withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()  // footer = blank, won't get mulitple separator lines after final row
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
    func setupNavigationStyle() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.lightRed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = UIColor.teal
        
        let company = companies[indexPath.row]
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

