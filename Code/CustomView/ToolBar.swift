//
//  ToolBar.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/09.
//  Copyright © 2020 Asu. All rights reserved.
//


import UIKit

class ToolBar: UIView {
    
    let btnDown = UIButton()
    let height: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        btnDown.translatesAutoresizingMaskIntoConstraints = false
        btnDown.setImage(
            UIImage(systemName: "keyboard.chevron.compact.down")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        btnDown.tintColor = Theme.accent
    }
    
    private func displayUI() {
        let size: CGFloat = 40
        
        addSubview(btnDown)
        
        NSLayoutConstraint.activate([
            btnDown.centerYAnchor.constraint(equalTo: centerYAnchor),
            btnDown.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            btnDown.widthAnchor.constraint(equalToConstant: size),
            btnDown.heightAnchor.constraint(equalToConstant: size),
        ])
    }
}

