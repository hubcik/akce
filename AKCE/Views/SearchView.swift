//
//  SearchView.swift
//  AKCE
//
//  Created by Hubert Gostomski on 27/12/2018.
//  Copyright © 2018 Hubert Gostomski. All rights reserved.
//

import UIKit

protocol SearchDelegateProtocol: class {
    func refilter(searchPhrase: String)
}

let CSEARCH_BAR_HEIGHT: CGFloat = dr.r(v: 40)

class SearchTextField: UIView, UITextFieldDelegate {
    
    weak var searchDelegate: SearchDelegateProtocol?
    
    lazy var textField: UITextField = {
        let tf: UITextField = UITextField(forAutoLayout:())
        
        tf.placeholder = NSLocalizedString("Search", comment: "")
        
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        
        tf.backgroundColor = UIColor.clear
        tf.returnKeyType = UIReturnKeyType.done
        
        tf.font = UIFont.systemFont(ofSize: dr.r(v: 14))
        
        tf.delegate = self
        tf.addTarget(self, action: #selector(textDidChange), for: UIControl.Event.editingChanged)
        
        return tf
    }()
    
    lazy var cancelButton:UIButton = {
        let b:UIButton = UIButton(type: .custom)
        b.backgroundColor = UIColor.clear
        b.addTarget(self, action: #selector(cancelButtonClicked), for: UIControl.Event.touchUpInside)
        
        b.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        
        b.setTitle(NSLocalizedString("Cancel", comment: ""), for: UIControl.State.normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: dr.r(v: 10.0))
        b.alpha = 0
        
        return b
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.textField)
        self.addSubview(self.cancelButton)
        
        self.updateColors()
        
        self.updateConstraints()
    }
    
    private func updateColors() {
        self.backgroundColor = COLOR_SEARCH_BACK
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: COLOR_SEARCH_PLACEHOLDER,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: dr.r(v: 12))
        ]
        
        self.textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search", comment: ""), attributes:attributes)
        self.textField.textColor = COLOR_SEARCH_FORE
        
        self.cancelButton.setTitleColor(COLOR_SEARCH_CANCEL, for: .normal)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.textField.autoPinEdge(.left, to: .left, of: self, withOffset: dr.r(v: 5))
        self.textField.autoPinEdge(.right, to: .left, of: self.cancelButton, withOffset: dr.r(v: 0))
        self.textField.autoPinEdge(.top, to: .top, of: self, withOffset: 1)
        self.textField.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
        
        self.cancelButton.autoPinEdge(.right, to: .right, of: self, withOffset: dr.r(v: -5))
        self.cancelButton.autoPinEdge(.top, to: .top, of: self, withOffset: 0)
        self.cancelButton.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -2)
        self.cancelButton.autoSetDimension(.width, toSize: dr.r(v: 50))
    }
    
    @objc func textDidChange() {
        if self.searchDelegate != nil {
            self.searchDelegate?.refilter(searchPhrase: self.textField.text!)
        }
    }
    
    @objc func cancelButtonClicked() {
        self.textField.text = ""
        self.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 0
        }
        self.searchDelegate?.refilter(searchPhrase: self.textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        if (textField.text == "")
        {
            UIView.animate(withDuration: 0.3) {
                self.cancelButton.alpha = 0
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 1
        }
    }
    
    public func getSearchText() -> String {
        return self.textField.text!
    }
}
