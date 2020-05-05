//
//  VCHomeTabBar.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/03.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCHomeTabBar: UIViewController {
    
    let separator = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.setCollectionViewLayout(layout, animated: true)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    weak var oldVC: UIViewController? = nil
    var index: Int = UserDefaults.standard.integer(forKey: KeyString.lastSelectedTabBarItem)
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        displayUI()
        registerCell()
        
        view.backgroundColor = Theme.background
        setTopBarColor()
    }
}

