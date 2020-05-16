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
    let ivArrow = UIImageView()
    
    var section: Int = -1
    var isComplete: Bool = false
    
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
        if self.ivArrow.transform == .identity {
            UIView.animate(withDuration: 0.3, animations: {
                self.ivArrow.transform = self.ivArrow.transform.rotated(by: .pi)
            })
            self.delegate?.foldingSection(section: section, isComplete: isComplete)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.ivArrow.transform = .identity
            })
            self.delegate?.unFoldingSection(section: section, isComplete: isComplete)
        }
    }
    
    private func setUpUI() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.setContents(diff: -3, line: 1)
        title.isUserInteractionEnabled = false
        
        ivArrow.translatesAutoresizingMaskIntoConstraints = false
        ivArrow.image = UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate)
        ivArrow.tintColor = Theme.accent.withAlphaComponent(0.5)
        ivArrow.contentMode = .scaleAspectFill
        ivArrow.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rotateArrow))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    private func displayUI() {
        addSubview(title)
        addSubview(ivArrow)
        
        let size: CGFloat = 14
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: ivArrow.leadingAnchor, constant: -15),
            
            ivArrow.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            ivArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            ivArrow.widthAnchor.constraint(equalToConstant: size),
            ivArrow.heightAnchor.constraint(equalToConstant: size),
        ])
    }
}
