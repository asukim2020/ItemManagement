//
//  CheckBox.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

protocol CheckBoxDelegate: class {
    func CheckBox(isOn: Bool)
}

class UICheckBox: UIView {
    
    weak var delegate: CheckBoxDelegate?
    let size: CGFloat = 18
    let border: CGFloat = 2
    
    var isOn: Bool = false {
        didSet {
            if self.isOn {
                checked()
            } else {
                unChecked()
            }
            delegate?.CheckBox(isOn: self.isOn)
        }
    }
    
    private let vwSquare = UIView()
    private let ivCheckBox = UIImageView()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: 가능하면 애니매이션 넣어보기
    @objc private func checked() {
        vwSquare.isHidden = true
        ivCheckBox.isHidden = false
    }
    
    @objc private func unChecked() {
        vwSquare.isHidden = false
        ivCheckBox.isHidden = true
    }
    
    private func setUpUI() {
        isUserInteractionEnabled = true
        
        vwSquare.translatesAutoresizingMaskIntoConstraints = false
        vwSquare.isUserInteractionEnabled = true
        vwSquare.layer.borderColor = Theme.accent.withAlphaComponent(0.7).cgColor
        vwSquare.layer.borderWidth = border
        vwSquare.layer.cornerRadius = 3
        
        let tapSquare = UITapGestureRecognizer(target: self, action: #selector(checked))
        vwSquare.addGestureRecognizer(tapSquare)
        vwSquare.isHidden = false
        
        ivCheckBox.translatesAutoresizingMaskIntoConstraints = false
        ivCheckBox.image = #imageLiteral(resourceName: "checkbox_fill.png").withRenderingMode(.alwaysTemplate)
        ivCheckBox.tintColor = Theme.accent.withAlphaComponent(0.7)
        ivCheckBox.contentMode = .scaleAspectFill
        ivCheckBox.isUserInteractionEnabled = true
        let tapCheckBox = UITapGestureRecognizer(target: self, action: #selector(unChecked))
        ivCheckBox.addGestureRecognizer(tapCheckBox)
        ivCheckBox.layer.cornerRadius = 4
        ivCheckBox.clipsToBounds = true
        ivCheckBox.isHidden = true
    }
    
    private func displayUI() {
        addSubview(vwSquare)
        addSubview(ivCheckBox)
        
        NSLayoutConstraint.activate([
            vwSquare.centerXAnchor.constraint(equalTo: centerXAnchor),
            vwSquare.centerYAnchor.constraint(equalTo: centerYAnchor),
            vwSquare.widthAnchor.constraint(equalToConstant: size),
            vwSquare.heightAnchor.constraint(equalToConstant: size),
            
            ivCheckBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            ivCheckBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            ivCheckBox.widthAnchor.constraint(equalToConstant: size),
            ivCheckBox.heightAnchor.constraint(equalToConstant: size)
        ])
    }
}
