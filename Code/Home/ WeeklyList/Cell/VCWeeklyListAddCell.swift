//
//  VCWeeklyListAddCell.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCWeeklyListAddCell: UITableViewCell {
    static let identifier: String = "VCWeeklyListAddCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let ivAdd = UIImageView()
    let lbAdd = UILabel()
    
    private func setUpUI() {
        backgroundColor = .clear
        
        ivAdd.translatesAutoresizingMaskIntoConstraints = false
        ivAdd.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        ivAdd.tintColor = Theme.accent
        ivAdd.contentMode = .scaleAspectFit
        
        lbAdd.translatesAutoresizingMaskIntoConstraints = false
        lbAdd.setContents(line: 1)
        lbAdd.text = NSLocalizedString("add_item", comment: "항목 추가")
    }
    
    private func displayUI() {
        let size: CGFloat = 18
        let margin: CGFloat = 12
        
        addSubview(ivAdd)
        addSubview(lbAdd)
        
        NSLayoutConstraint.activate([
            ivAdd.centerYAnchor.constraint(equalTo: lbAdd.centerYAnchor),
            ivAdd.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            ivAdd.widthAnchor.constraint(equalToConstant: size),
            ivAdd.heightAnchor.constraint(equalToConstant: size),
            
            lbAdd.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            lbAdd.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            lbAdd.leadingAnchor.constraint(equalTo: ivAdd.trailingAnchor, constant: 15),
            lbAdd.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}

