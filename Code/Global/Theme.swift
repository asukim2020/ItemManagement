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
    
    static var bar: UIColor = isDarkMode ? UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1) : .white
    
    static var font: UIColor = isDarkMode ? UIColor(hexString: "#FAFAFA") : UIColor(hexString: "#202020")
    
    // TODO: - 색상보고 변경할 것
    static var lightFont: UIColor = isDarkMode ? .lightGray : .lightGray
    
    static var rootBackground: UIColor = isDarkMode ? .black : UIColor(hexString: "#FAFAFA")
    
    static var background: UIColor = isDarkMode ? UIColor(hexString: "#202020") : UIColor(hexString: "#FAFAFA")
    
    static var accent: UIColor = isDarkMode ? UIColor(hexString: "#FAFAFA") : UIColor(hexString: "#202020")
//        UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
    
    static var separator: UIColor = UIColor.lightGray.withAlphaComponent(0.2)
}
