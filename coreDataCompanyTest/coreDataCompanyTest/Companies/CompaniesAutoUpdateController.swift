//
//  CompaniesAutoUpdateController.swift
//  coreDataCompanyTest
//
//  Created by admin on 3/1/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
//    let fetchedResultsController: NSFetchedResultsController<Company> = {  //adding frc.delegate killed this line
    lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        
        frc.delegate = self  //adding this line requires us to add 'NSFetchedResultsControllerDelegate' protocol to class definition
        
        do {
          try  frc.performFetch()
        } catch let err {
            print("Error fetching data: ", err)
        }
        return frc
    }()
    
    let cellId = "cellId"
    
    
    @objc private func handleAdd(){
        print("Let's add a company called BMW")
    
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = Company(context: context)   //NSManagedObject constructor
        company.name = "zzz"
    
        try? context.save()
    }
    
    @objc private func handleDelete(){
        print("TRYING TO DELETE ....")
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
//        request.predicate = NSPredicate(format: "name contains %@", "B")  //when commented out, EVERYTHING fetched is selected for delete
        //not selective before action
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let companiesWithB = try? context.fetch(request)
    
    
        companiesWithB?.forEach { (company) in
            context.delete(company)
        }
        
        try? context.save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkBlue
        navigationItem.title = "Auto Updates"
        
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
            ]
        
//                tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)  //#1
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        fetchedResultsController.fetchedObjects?.forEach({ (company) in
            print("===================")
            print(company.name ?? "")
        })
        
       
//        Service.shared.downloadCompaniesFromServer()
        
        //This controller is AWESOME!!
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func handleRefresh(){
        Service.shared.downloadCompaniesFromServer()
        self.refreshControl?.endRefreshing()  //without this line, dragging down second time doesn't make it pull companies a second time.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = "HEADER"
        label.backgroundColor = UIColor.lightBlue
        label.text = fetchedResultsController.sectionIndexTitles[section] //#2
        return label
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)  //#1
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        let company = fetchedResultsController.object(at: indexPath)

//        cell.textLabel?.text = "1234"
      
//        cell.textLabel?.text = company.name
 
        cell.company = company  //Look at CompanyCell.swift
                                //feed it 'var company' and then everything else in the cell auto-fills
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .left)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName   //#2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let employeesListController = EmployeesController()
        employeesListController.company = fetchedResultsController.object(at: indexPath)
        
        navigationController?.pushViewController(employeesListController, animated: true)
    }
    
}












