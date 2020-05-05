//
//  Theme.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/04.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

// 테마 관리 클래스
// 일반 모드, 다크 모드 만 지원

class Theme {
    
    static var isDarkMode: Bool = {
        return UITraitCollection.current.userInterfaceStyle == .dark
    }()
    
    static var bar: UIColor = {
        return isDarkMode ? UIColor.gray.withAlphaComponent(0.15) : .white
    }()
    
    static var font: UIColor = {
        return isDarkMode ? .white : .darkGray
    }()
    
    static var background: UIColor = {
        return isDarkMode ? UIColor(hexString: "#202020") : UIColor(hexString: "#FAFAFA")
    }()
    
    static var accent: UIColor = {
//        return UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
        return isDarkMode ? UIColor(hexString: "#FAFAFA") : .darkGray
    }()
    
    static var separator: UIColor = {
        return UIColor.lightGray.withAlphaComponent(0.2)
    }()
}
