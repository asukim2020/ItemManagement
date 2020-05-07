//
//  VCHomeTabBar.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/03.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCHomeTabBar: UIViewController {
    
    var height: CGFloat = 48
    var count: Int { return HomeTabBar.allCases.count }
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
        
        view.backgroundColor = Theme.rootBackground
        setTopBarColor()
    }
    
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
            separator.heightAnchor.constraint(equalToConstant: Global.separatorSize),
        ])
    }
    
    func loadVC(vc: UIViewController) {
        guard let v = vc.view else { return }
        if let oldVC = self.oldVC {
            unloadVC(vc: oldVC)
        }
        
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
    
    func unloadVC(vc: UIViewController) {
        guard let v = vc.view else { return }

        v.removeFromSuperview()
        vc.removeFromParent()
        self.oldVC = nil
    }
}

