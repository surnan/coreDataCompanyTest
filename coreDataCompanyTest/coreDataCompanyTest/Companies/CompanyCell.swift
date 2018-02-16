//
//  CompanyCell.swift
//  coreDataCompanyTest
//
//  Created by admin on 2/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {  //triggered from 'cellForRowAt' cell.company=company
        didSet {
            print(company?.name)
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            nameFoundedDateLabel.text = company?.name
            
            if let name = company?.name, let founded = company?.founded {
                // One way to show date
                //            let locale = Locale(identifier: "EN")
                //            let dateString = "\(name) - Founded: \(founded.description(with: locale))"
                //MMM dd, YYYY
                let dateFormatter = DateFormatter()
                //            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss" // <-- Will show hour, minute, seconds also
                dateFormatter.dateFormat = "MMM dd, yyyy"  //first 3 letters of month date, 4-digit year
                let foundedDateString = dateFormatter.string(from: founded)
                let dateString = "\(name) - Founded: \(foundedDateString)"
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
    
    //custom image view
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "COMPANY NAME"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.teal
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
