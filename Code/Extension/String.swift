//
//  String.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/07.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension String {
    
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        
        attributeString.addAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: Global.fontSize),
             NSAttributedString.Key.strikethroughColor: Theme.lightFont,
             .foregroundColor: Theme.lightFont,
             NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.thick.rawValue
            )],
            range: NSMakeRange(0, attributeString.length)
        )
        
        return attributeString
    }
}
