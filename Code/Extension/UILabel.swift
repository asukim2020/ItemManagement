
//
//  UILabel.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension UILabel {
    func setContents() {
        font = UIFont.systemFont(ofSize: Global.fontSize)
        textColor = Theme.font
        numberOfLines = 0
        textAlignment = .left
    }
}

extension UITextView {
    func setContents() {
        font = UIFont.systemFont(ofSize: Global.fontSize)
        textColor = Theme.font
        textAlignment = .left
        text = " "
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        layer.cornerRadius = 4
        layer.borderColor = Theme.accent.withAlphaComponent(0.35).cgColor
        layer.borderWidth = 1
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    // TODO: - 라벨 높이, 너비 구할 때 사용할 것 (현재 사용되지 않고 있음, 하지만 나중에 코드가 필요함)
    func getTextHeight() -> CGFloat {
        let size = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: Global.fontSize)])
        let vwWidth = bounds.width
        let height = size.height
        print("size: \(size)")
        return CGFloat(Int(size.width / vwWidth) + 1) * height
    }
}
