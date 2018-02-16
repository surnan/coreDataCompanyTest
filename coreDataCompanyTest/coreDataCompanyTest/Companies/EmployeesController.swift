//
//  EmployeesController.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    var company: Company?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    
    @objc func handleAdd(){
        print("Trying to add an employee")
        
        let createEmployeeController = CreateEmployeeController()
        
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    
}
