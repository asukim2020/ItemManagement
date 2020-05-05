//
//  VCHomeTabBar + UI.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/04.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

// MARK: - extension VCHomeTabBar
extension VCHomeTabBar {
    
    var separatorHeight: CGFloat { return 0.7 }
    var height: CGFloat { return 48 }
    var count: Int { return HomeTabBar.allCases.count }
    
    func setUpUI() {
        collectionView.backgroundColor = Theme.bar
        collectionView.delegate = self
        collectionView.dataSource = self
        
        separator.backgroundColor = Theme.separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func displayUI() {
        view.addSubview(collectionView)
        view.addSubview(separator)
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.bottomAnchor, constant: -height),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            separator.topAnchor.constraint(equalTo: collectionView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: separatorHeight),
        ])
    }
    
    func loadVC(vc: UIViewController) {
        guard let v = vc.view else { return }
        self.oldVC?.removeFromParent()
        
        addChild(vc)
        view.addSubview(vc.view)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: safe.topAnchor),
            v.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            v.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
        ])
        
        self.oldVC = vc
    }
}

