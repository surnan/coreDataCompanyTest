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
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        print("EDITING COMPANY")
        print("EDITING COMPANY")
        print("EDITING COMPANY")
        print("EDITING COMPANY")
        
        let row = companies.index(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    var companies = [Company]()
    
    private func fetchCompanies(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach({ (company) in
                print(company.name ?? "")
            })
            self.companies = companies
            self.tableView.reloadData()
        } catch let fetchErr {
            print("Failed to fetch companies: ", fetchErr)
        }
        print("companies.count = \(companies.count)")
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
        if let name = company.name, let founded = company.founded {
            
            // One way to show date
            //            let locale = Locale(identifier: "EN")
            //            let dateString = "\(name) - Founded: \(founded.description(with: locale))"
            
            //MMM dd, YYYY
            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss" // <-- Will show hour, minute, seconds also
            dateFormatter.dateFormat = "MMM dd, yyyy"  //first 3 letters of month date, 4-digit year
            let foundedDateString = dateFormatter.string(from: founded)
            let dateString = "\(name) - Founded: \(foundedDateString)"
            cell.textLabel?.text = dateString
        } else {
            cell.textLabel?.text = company.name
        }
        
        //        cell.textLabel?.text = "\(company.name) - Founded: \(company.founded)"
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")
        
        if let imageData = company.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            print("Attempting to delete company: ", company.name ?? "")
            self.companies.remove(at: indexPath.row)   //array that populates tableView //<-- without this, it crashes on next line
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete company: ", saveErr)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        print("Editing company: ")
        return [deleteAction, editAction]
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("Editing company in separate function")
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.delegate = self   //<--- missing that line has caused me LOTS LOTS LOTS of pain
        // (os/kern) invalid capability (0x14) "Unable to insert COPY_SEND"
        
        //Below is changing values in the VC before it loads.  So although we're calling 'CreateCompanyController'
        //it still looks customized for the current situation
        editCompanyController.company = companies[indexPath.row]
        
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true, completion: nil)
    }
}
