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
        
//        fetchEmployees()  //where we define the arrays for each section
//        tableView.reloadData() //<-- don't need to reload data since we're inserting it instead
                                //All the code below is new
        
        guard let section = employeeTypes.index(of: employee.type!) else { return }
        let row = allEmployees[section].count
        
        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .right)
        
    }
    
    var company: Company?

    let cellID = "cellllllllllllllll"

    override func viewDidLoad(){
        super.viewDidLoad()
        fetchEmployees()
        view.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    
    var employeeTypes = [EmployeeType.Executive.rawValue,
                         EmployeeType.SeniorManagement.rawValue,
                         EmployeeType.Staff.rawValue,
                         EmployeeType.Intern.rawValue]
    
    

    private func fetchEmployees() {
        
        allEmployees = []  //prevents you from index out of bounds on the append from employeeTypes.append
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        
        
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(companyEmployees.filter { $0.type == employeeType})  //Very slick
        
        
//        let executives = companyEmployees.filter { (employee) -> Bool in
//            return employee.type == EmployeeType.Executive.rawValue
//        }
//        let seniorManagement = companyEmployees.filter { $0.type == EmployeeType.SeniorManagement.rawValue}
//        allEmployees = [executives, seniorManagement, companyEmployees.filter {$0.type == EmployeeType.Staff.rawValue} ]
    }
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
//        if section == 0 {
//            label.text = EmployeeType.Executive.rawValue
//        } else if section == 1{
//            label.text = EmployeeType.SeniorManagement.rawValue
//        } else {
//            label.text = EmployeeType.Staff.rawValue
//        }
//
        label.text = employeeTypes[section]
        
        
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
