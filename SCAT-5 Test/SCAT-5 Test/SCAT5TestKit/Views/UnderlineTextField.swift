//
//  UnderlineTextField.swift
//  Smart Training Log
//

import UIKit

class UnderlineTextField: UITextField {

    @IBInspectable var normalUnderlineColor: UIColor = .lightGray
    @IBInspectable var selectedUnderlineColor: UIColor = .blue
    
    private var underlineView: UIView
    
    override init(frame: CGRect) {
        underlineView = UIView()
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        underlineView = UIView()
        super.init(coder: aDecoder)
        commonInit()
    }

    override func becomeFirstResponder() -> Bool {
        let responder = super.becomeFirstResponder()
        if responder {
            underlineView.backgroundColor = selectedUnderlineColor
        }
        return responder
    }

    override func resignFirstResponder() -> Bool {
        let resign = super.resignFirstResponder()
        if resign {
            underlineView.backgroundColor = normalUnderlineColor
        }
        return resign
    }
    
    private func commonInit() {
        underlineView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1))
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = UIColor.lightGray
        addSubview(underlineView)
        
        underlineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        underlineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
}
