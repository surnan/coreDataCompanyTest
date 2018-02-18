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
        print("Trying to Fetch employees")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Employee>(entityName: "Employee")  //Typing <Employee> makes it return an array of Employee
        do {
            let employees = try context.fetch(request)
            self.employees = employees
            
//            employees.forEach{print("Employee name: ", $0.name ?? "")}
            } catch let err {
                print("Failed to fetch employees: ", err)
            }
        }
    
    @objc func handleAdd(){
        print("Trying to add an employee")
        let createEmployeeController = CreateEmployeeController()
        
        createEmployeeController.delegate = self
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
