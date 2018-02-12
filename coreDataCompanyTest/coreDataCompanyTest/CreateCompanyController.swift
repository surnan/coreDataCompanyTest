//
//  CreateCompanyController.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

//Custom Delegation
protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}


class CreateCompanyController: UIViewController {
    
    var company: Company? {  //Without this line, 'editCompanyController.company = companies[indexPath.row]' errors out
                            // keeps track of which company we are trying to edit
                            //'ViewWillAppear' to determine Navigation Title in ternary operator
                            //'handleAddCompany' created 'CreateCompanyController' but doesn't define 'Company?'
        didSet {
            nameTextField.text = company?.name
        }
    }
    
    
    
    var delegate: CreateCompanyControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company": "Edit Company"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = UIColor.darkBlue
        setupUI()
    }
    
    @objc private func handleSave(){
        
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    
    private func saveCompanyChanges(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text //company = 'Company type' -> coreData object.  Edit here then 'context.save()' below

        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didEditCompany(company: self.company!)
            })
            
        } catch let saveErr {
            print(("Save Error: ", saveErr))
        }
        
    }
    
    
    
    private func createCompany() {
        print("trying to save company")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        do {
            try context.save()  //<--- That's the actual save
            dismiss(animated: true, completion: {
                self.delegate?.didAddCompany(company: company as! Company)
            })
        } catch let saveErr {
            print("Failed to save company: ", saveErr)
        }
    }
    
    
    
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI(){
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
    }

}
