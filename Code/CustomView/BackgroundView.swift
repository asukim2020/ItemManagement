//
//  BackgroundView.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/12.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        
        setUpUI(backgroundColor)
        self.backgroundColor = Theme.background
    }
    
    let view = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(_ backgroundColor: UIColor = Theme.background) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
