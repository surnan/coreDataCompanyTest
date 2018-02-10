//
//  CreateCompanyController.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        view.backgroundColor = UIColor.darkBlue
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
