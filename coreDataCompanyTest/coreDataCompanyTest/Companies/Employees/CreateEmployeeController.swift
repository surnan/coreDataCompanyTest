//
//  CreateEmployeeController.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var company: Company?
    var delegate: CreateEmployeeControllerDelegate?
    
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
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "MM/dd/yyyy"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Date"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Employee"
        view.backgroundColor = UIColor.darkBlue
        setupCancelButton()
        setupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    
    @objc private func handleSave(){
        print("Saving Employee")
        guard let employeeName = nameTextField.text else {return}
        guard let company = company else {return}
        guard let birthDayText = birthdayTextField.text else { return }
        
        if birthDayText.isEmpty {
            showError(title: "Invalid Name", message: "Please enter value for name")
            return  //you don't want to run the rest of this code and create an employee
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let birthdayDate = dateFormatter.date(from: birthDayText)
            else {
                showError(title: "Invalid Date", message: "Please enter date in the following format: MMM/dd/yyyy")
                return
        }

        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, birthday: birthdayDate, company: company)
        if let error = tuple.1 {
            //perhaps a UIAlert controller to show your message?
            print(error)
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            })
        }
    }
    
    
    private func showError(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        return  //you don't want to run the rest of this code and create an employee
    }
    
    
    private func setupUI(){
          _ = setupLightBlueBackgroundView(height: 100)
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
    
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    
        view.addSubview(birthdayTextField)
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
    
    }
}
