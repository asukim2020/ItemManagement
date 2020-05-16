//
//  VCWeeklyListItemHeader.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/12.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

protocol VCWeeklyListItemHedaerDelegate: class {
    func foldingSection(section: Int, isComplete: Bool)
    func unFoldingSection(section: Int, isComplete: Bool)
}

class VCWeeklyListItemHedaer: UITableViewHeaderFooterView {
    static let identifier: String = "VCWeeklyListItemHedaer"
    weak var delegate: VCWeeklyListItemHedaerDelegate?
    
    let title = UILabel()
    let ivUpArrow = UIImageView()
    let ivDownArrow = UIImageView()
    
    var section: Int = -1
    var isComplete: Bool = false
    var foldingFlag: Bool = false {
        didSet {
            if foldingFlag {
                ivUpArrow.isHidden = true
                ivDownArrow.isHidden = false
            } else {
                ivUpArrow.isHidden = false
                ivDownArrow.isHidden = true
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = BackgroundView(backgroundColor: Theme.separator)
        
        setUpUI()
        displayUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(time: TimeInterval) {
        let date = Date(timeIntervalSince1970: time)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.locale = Global.locale
        formatter.dateStyle = .long
        title.text = formatter.string(from: date)
    }
    
    func setTitle(title: String) {
        self.title.text = title
    }
    
    @objc func rotateArrow() {
        if !foldingFlag {
            self.delegate?.foldingSection(section: section, isComplete: isComplete)
        } else {
            self.delegate?.unFoldingSection(section: section, isComplete: isComplete)
        }
    }
    
    private func setUpUI() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.setContents(diff: -3, line: 1)
        title.isUserInteractionEnabled = false
        
        ivUpArrow.translatesAutoresizingMaskIntoConstraints = false
        ivUpArrow.image = UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate)
        ivUpArrow.tintColor = Theme.accent.withAlphaComponent(0.5)
        ivUpArrow.contentMode = .scaleAspectFill
        ivUpArrow.isUserInteractionEnabled = false
        
        ivDownArrow.translatesAutoresizingMaskIntoConstraints = false
        ivDownArrow.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        ivDownArrow.tintColor = Theme.accent.withAlphaComponent(0.5)
        ivDownArrow.contentMode = .scaleAspectFill
        ivDownArrow.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rotateArrow))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    private func displayUI() {
        addSubview(title)
        addSubview(ivUpArrow)
        addSubview(ivDownArrow)
        
        let size: CGFloat = 14
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: ivUpArrow.leadingAnchor, constant: -15),
            
            ivUpArrow.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            ivUpArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            ivUpArrow.widthAnchor.constraint(equalToConstant: size),
            ivUpArrow.heightAnchor.constraint(equalToConstant: size),
            
            ivDownArrow.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            ivDownArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            ivDownArrow.widthAnchor.constraint(equalToConstant: size),
            ivDownArrow.heightAnchor.constraint(equalToConstant: size),
        ])
    }
}
