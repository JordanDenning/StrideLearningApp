//
//  UserCell.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/20/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let date = Date()
                
                let dateFormatter = DateFormatter()
                if Calendar.current.isDateInYesterday(timestampDate) {
                    timeLabel.text = "Yesterday"
                } else {
                    if Calendar.current.isDateInToday(timestampDate){
                        dateFormatter.dateFormat = "hh:mm a"
                    } else if Calendar.current.isDate(timestampDate, equalTo: date, toGranularity: .weekOfYear) {
                        dateFormatter.dateFormat = "EEEE"
                    } else {
                        dateFormatter.dateFormat = "M/d/yy"
                    }
                    
                    timeLabel.text = dateFormatter.string(from: timestampDate)
                }
            }
 
        }
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    self.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenSize = UIScreen.main.bounds.width
        let textScreen = screenSize - 140
        let detailScreen = screenSize - 110
        
        
        let textWidth = textLabel!.frame.width < textScreen ?  textLabel!.frame.width : textScreen
        let detailWidth = detailTextLabel!.frame.width < detailScreen ?  detailTextLabel!.frame.width : detailScreen
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textWidth, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailWidth, height: detailTextLabel!.frame.height)
        
        detailTextLabel?.numberOfLines = 1
        textLabel?.numberOfLines = 1
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor(r:16, g:153, b:255).cgColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(r: 16, g:153, b:255)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
