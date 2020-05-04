//
//  VCHomeTabBar + UI.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/04.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

// MARK: - tabbar type
enum HomeTabBar: CaseIterable {
    case weeklyList
    case calender
    case memo
    case more
    
    func getEdgeImage() -> UIImage? {
        switch self {
        case .weeklyList:
            return UIImage(named: "list")
        case .calender:
            return UIImage(named: "calendar")
        case .memo:
            return UIImage(systemName: "lightbulb")
        case .more:
            return UIImage(named: "more")
        }
    }
    
    func getFillImage() -> UIImage? {
        switch self {
        case .weeklyList:
            return UIImage(named: "list_fill")
        case .calender:
            return UIImage(named: "calendar_fill")
        case .memo:
            return UIImage(systemName: "lightbulb.fill")
        case .more:
            return UIImage(named: "more_fill")
        }
    }
}

// MARK: - extension VCHomeTabBar
extension VCHomeTabBar {
    
    var separatorHeight: CGFloat { return 0.7 }
    var height: CGFloat { return 48 }
    var count: Int { return HomeTabBar.allCases.count }
    
    func setUpUI() {
        collectionView.backgroundColor = Theme.bar
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        
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
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            
            separator.topAnchor.constraint(equalTo: collectionView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: separatorHeight),
        ])
    }
}


// MARK: - CollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension VCHomeTabBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        let edgeImg = HomeTabBar.allCases[indexPath.row].getEdgeImage()
        let fillImg = HomeTabBar.allCases[indexPath.row].getFillImage()
        cell.setImage(defaultIv: edgeImg, selectedIv: fillImg)
        return cell
    }
    
    // TODO: - 클릭 이벤트 등록
    // TODO: - 클릭 애니매이션 등록
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for (idx, _) in HomeTabBar.allCases.enumerated() {
            let cell = collectionView.cellForItem(at: IndexPath(row: idx, section: 0)) as! Cell
            cell.deavtiveImage()
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        cell.activeImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size
        let width = size.width / CGFloat(count)
        return CGSize(width: width, height: height)
    }
}


// MARK: - Cell
fileprivate class Cell: UICollectionViewCell {
    static let identifier: String = "cell"
    let size: CGFloat = 25
    
    let defaultIv = UIImageView()
    let selectedIv = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        displayUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activeImage() {
        defaultIv.isHidden = true
        selectedIv.isHidden = false
    }
    
    func deavtiveImage() {
        defaultIv.isHidden = false
        selectedIv.isHidden = true
    }
    
    func setImage(defaultIv: UIImage?, selectedIv: UIImage?) {
        guard self.defaultIv.image == nil
            && self.selectedIv.image == nil
            && defaultIv != nil
            && selectedIv != nil
            else { return }
        
        self.defaultIv.image = defaultIv?.withRenderingMode(.alwaysTemplate)
        self.defaultIv.tintColor = Theme.accent
        
        self.selectedIv.image = selectedIv?.withRenderingMode(.alwaysTemplate)
        self.selectedIv.tintColor = Theme.accent
    }
    
    // TODO: 추후 color 지정
    private func setUpUI() {
        contentView.backgroundColor = .clear
        
        defaultIv.image = nil
        defaultIv.translatesAutoresizingMaskIntoConstraints = false
        defaultIv.isHidden = false
        
        selectedIv.image = nil
        selectedIv.translatesAutoresizingMaskIntoConstraints = false
        selectedIv.isHidden = true
    }
    
    private func displayUI() {
        addSubview(defaultIv)
        addSubview(selectedIv)
        
        NSLayoutConstraint.activate([
            defaultIv.centerXAnchor.constraint(equalTo: centerXAnchor),
            defaultIv.centerYAnchor.constraint(equalTo: centerYAnchor),
            defaultIv.widthAnchor.constraint(equalToConstant: size),
            defaultIv.heightAnchor.constraint(equalToConstant: size),
            
            selectedIv.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectedIv.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedIv.widthAnchor.constraint(equalToConstant: size),
            selectedIv.heightAnchor.constraint(equalToConstant: size),
        ])
    }
}
