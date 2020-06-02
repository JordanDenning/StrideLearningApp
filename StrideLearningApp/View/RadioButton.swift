//
//  RadioButton.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 5/29/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit

class RadioButton: UIView {
    var button: UIButton = {
        let button = UIButton()
        var image = UIImage(named: "notDone")
        var selected = UIImage(named: "done4")
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(selected, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(r: 50, g: 50, b: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
      }
      
      //initWithCode to init view from xib or storyboard
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
      }
      
    func setupView(){
        addSubview(button)
        addSubview(label)

        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        label.leftAnchor.constraint(equalTo: button.rightAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
       return CGSize(width: 80, height: 25)
    }

}
