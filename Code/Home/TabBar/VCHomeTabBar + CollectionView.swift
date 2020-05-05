//
//  VCHomeTabBar + CollectionView.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/05.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

// MARK: - tabbar type
enum HomeTabBar: CaseIterable {
    case weeklyList
    case calender
    case ideaNode
    case more
    
    func getEdgeImage() -> UIImage? {
        switch self {
        case .weeklyList:
            return UIImage(named: "list")
        case .calender:
            return UIImage(named: "calendar")
        case .ideaNode:
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
        case .ideaNode:
            return UIImage(systemName: "lightbulb.fill")
        case .more:
            return UIImage(named: "more_fill")
        }
    }
    
    func getVC() -> UIViewController {
        switch self {
        case .weeklyList:
            return VCWeeklyList()
        case .calender:
            return VCCalender()
        case .ideaNode:
            return VCIdeaNote()
        case .more:
            return VCMore()
        }
    }
}


// MARK: - CollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension VCHomeTabBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func registerCell() {
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        let edgeImg = HomeTabBar.allCases[indexPath.row].getEdgeImage()
        let fillImg = HomeTabBar.allCases[indexPath.row].getFillImage()
        cell.setImage(defaultIv: edgeImg, selectedIv: fillImg)
        
        if index == indexPath.row {
            let vc = HomeTabBar.allCases[index].getVC()
            loadVC(vc: vc)
            cell.activeImage()
        }
        
        return cell
    }
    
    // TODO: - 클릭 애니매이션 등록
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for (idx, _) in HomeTabBar.allCases.enumerated() {
            let cell = collectionView.cellForItem(at: IndexPath(row: idx, section: 0)) as! Cell
            cell.deavtiveImage()
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        cell.activeImage()
        
        let vc = HomeTabBar.allCases[indexPath.row].getVC()
        self.loadVC(vc: vc)
        
        UserDefaults.standard.set(indexPath.row, forKey: KeyString.lastSelectedTabBarItem)
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
