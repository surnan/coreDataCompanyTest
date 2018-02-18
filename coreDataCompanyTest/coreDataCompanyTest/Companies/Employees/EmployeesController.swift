//
//  EmployeesController.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    
    func didAddEmployee(employee: Employee) {   //  Without this protocol, the delagate to "self" fails
                                                //  'createEmployeeController.delegate = self'
                                                //  defined within 'createEmployeeController
        employees.append(employee)
        tableView.reloadData()
    }
    
    var company: Company?
    
    var employees = [Employee]()
    let cellID = "cellllllllllllllll"

    override func viewDidLoad(){
        super.viewDidLoad()
        fetchEmployees()
        view.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func fetchEmployees(){
        
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        self.employees = companyEmployees
    }
    
    @objc func handleAdd(){
        print("Trying to add an employee")
        let createEmployeeController = CreateEmployeeController()
        
        createEmployeeController.delegate = self
        createEmployeeController.company = self.company
        
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let employee = employees[indexPath.row]
        if let taxId = employee.employeeInformation?.taxId {
            cell.textLabel?.text = "\(employee.name ?? "")    \(taxId)"
        } else {
            cell.textLabel?.text = "\(employee.name ?? "")"
        }
        
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "")    \(dateFormatter.string(from: birthday))"
        }
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.teal
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
}
