//
//  TaskCell.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 5/26/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

protocol HeightForTextView {
    func heightOfTextView(height: CGFloat)
}

protocol ToggleCheckBox {
    func toggleCheckBox(_ sender: UIButton)
}

protocol EditTask {
    func editTask(task: String, textView: UITextView)
}

class TaskCell: UITableViewCell, UITextViewDelegate {
    
    var delegate:(HeightForTextView & ToggleCheckBox & EditTask)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        let sizeThatShouldFitTheContent = textView.sizeThatFits(textView.frame.size)
        let height = sizeThatShouldFitTheContent.height
        textView.isScrollEnabled = false
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    let checkMark: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "notDone"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        addSubview(textView)
        addSubview(checkMark)
        
        textView.delegate = self
        
        checkMark.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9).isActive = true
        checkMark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkMark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkMark.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true

        checkMark.addTarget(self, action: #selector(pressedButton(_:)), for: .touchUpInside)
        
        textView.leftAnchor.constraint(equalTo: checkMark.rightAnchor, constant: 4).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            if let delegate = self.delegate {
                let text = textView.text!
                delegate.editTask(task: text, textView: textView)
            }
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth: CGFloat = textView.frame.size.width
        let newSize: CGSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        if let delegate = self.delegate {

            delegate.heightOfTextView(height: newSize.height)
        }
    }
    
    @objc func pressedButton(_ sender: UIButton){
        if let delegate = self.delegate {
            delegate.toggleCheckBox(sender)
        }
    }
    
}
