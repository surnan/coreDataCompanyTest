//
//  Service.swift
//  coreDataCompanyTest
//
//  Created by admin on 3/1/18.
//  Copyright © 2018 admin. All rights reserved.
//


//  https://api.letsbuildthatapp.com/intermediate_training/companies
import Foundation

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        print("Attempting to download stuff....")
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            print("Finished downloading")
            
            if let err = err {
                print("FAILED TO DOWNLOAD COMPANIES: ", err)
                return
            }
            
            guard let data = data else {return}
            
//            let string = String(data: data, encoding: .utf8)
//            print(string)
            
            let jsonDecoder = JSONDecoder() //1
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data) //1
                jsonCompanies.forEach({ (jsonCompany) in
                    print(jsonCompany.name)
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print("   \(jsonEmployee.name)")
                    })
                })
            } catch let jsonErr {
                print("Unable to pull companies via JSON: ", jsonErr)
            }
            
        }.resume()   //DO NOT FORGET THIS LINE
    }
}

//Decodable introduced in Swift 4.  No need for the old dictionary drama from previous swift
struct JSONCompany: Decodable { //1
    let name: String
    let founded: String  //keys must have spelling that matches the JSON contents you're pulling from 'foundd' won't compile
    var  employees:  [JSONEmployee]? //have to be optional because not all company in our JSON has employees
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}



//COPY/PASTA of json data below
/*
 [
 {
 "name": "Apple",
 "photoUrl": "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/467e07c1-da78-4f79-81e9-5274f05cf405",
 "founded": "04/01/1976",
 "employees": [
 {
 "name": "Billy",
 "birthday": "12/25/2000",
 "type": "Staff"
 },
 {
 "name": "Cheryl",
 "birthday": "07/04/1990",
 "type": "Senior Management"
 },
 {
 "name": "Dave",
 "birthday": "05/05/1492",
 "type": "Staff"
 },
 {
 "name": "Michael",
 "birthday": "02/14/1420",
 "type": "Staff"
 },
 {
 "name": "Steve Jobs",
 "birthday": "2/24/1955",
 "type": "Executive"
 },
 {
 "name": "Tim Cook",
 "birthday": "11/1/1960",
 "type": "Executive"
 },
 {
 "name": "Craig F.",
 "birthday": "03/27/1969",
 "type": "Executive"
 }
 ]
 },
 {
 "name": "Google",
 "photoUrl": "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/1482794c-db3f-4ca8-bfba-3117977cebb4",
 "founded": "09/04/1998"
 },
 {
 "name": "Microsoft",
 "photoUrl": "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/e7092b54-d59b-4e5f-941b-d17107db3e7e",
 "founded": ""
 },
 {
 "name": "Tesla",
 "photoUrl": "https://pbs.twimg.com/profile_images/782474226020200448/zDo-gAo0_400x400.jpg",
 "founded": ""
 },
 {
 "name": "Uber",
 "photoUrl": "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/80d8afd1-ac2e-4260-b56c-eb8aa95fa5f4",
 "founded": ""
 },
 {
 "name": "Twitter",
 "photoUrl": "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/67722930-bd5f-4d9c-b12d-8d835cd2221f",
 "founded": ""
 },
 {
 "name": "Facebook",
 "photoUrl": "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6083c592-0630-47b5-9b62-97c291790c69",
 "founded": "02/04/2004"
 }
 ]
 */
