//
//  EmployeesController.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel{
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}


class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    //This is called when we dismiss employee creation
    func didAddEmployee(employee: Employee) {   //  Without this protocol, the delagate to "self" fails
                                                //  'createEmployeeController.delegate = self'
                                                //  defined within 'createEmployeeController
//        employees.append(employee)
        fetchEmployees()  //where we define the arrays for each section
        
        tableView.reloadData()
    }
    
    var company: Company?
    
//    var employees = [Employee]()
    let cellID = "cellllllllllllllll"

    override func viewDidLoad(){
        super.viewDidLoad()
        fetchEmployees()
        view.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        let executives = companyEmployees.filter { (employee) -> Bool in
            return employee.type == "Executive"
        }
        
        let seniorManagement = companyEmployees.filter { $0.type == "Senior Management"}

        allEmployees = [executives, seniorManagement, companyEmployees.filter {$0.type == "Staff"} ]
        
  
    }
    
    
    var allEmployees = [[Employee]]()
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        if section == 0 {
            label.text = "Executive"
        } else if section == 1{
            label.text = "Senior Management"
        } else {
            label.text = "Staff"
        }
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
//        let employee = indexPath.section == 0 ?
//            shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
////        let employee = employees[indexPath.row]
        
        
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        
        
        
        
        cell.textLabel?.text = employee.name
        
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

        return allEmployees[section].count
        
        //        if section == 0 {
//            return shortNameEmployees.count
//        } else {
//            return longNameEmployees.count
//        }
    }
}
