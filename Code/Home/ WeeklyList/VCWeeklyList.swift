//
//  VCWeeklyList.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/04.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class ItemsInfo {
    var time: TimeInterval
    var isComplete: Bool
    var items: [Item]
    var foldingFlag: Bool
    var count: Int
    
    init(time: TimeInterval,
         isComplete: Bool,
         items: [Item],
         foldingFlag: Bool,
         count: Int
    ) {
        self.time = time
        self.isComplete = isComplete
        self.items = items
        self.foldingFlag = foldingFlag
        self.count = count
    }
}

class VCWeeklyList: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let toolBar = ToolBar()
    var toolBarConstraint: NSLayoutConstraint?
    // TODO: - 2차원 배열로 변경할 것 - 7일치 데이터 받아아도록
    var data: [ItemsInfo] = []
    var editIndex: IndexPath?
    var keyboardHideFlag: Bool = false
    var foldingFlag: Bool = false
    weak var inputActive: VCWeeklyListItemCell?
    var tableViewContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        
        setUpUI()
        displayUI()
        registerCell()
        
        // TODO: 여러일 데이터도 받을 수 있도록 수정
        if let data = Item.getDayList(date: Date()) {
            let info = ItemsInfo(time: data[0].toDay,
                                 isComplete: data[0].isComplete,
                                 items: data,
                                 foldingFlag: false,
                                 count: data.count)
            self.data.append(info)
        } else {
            let info = ItemsInfo(time: Date().timeIntervalSince1970,
                                 isComplete: false,
                                 items: [],
                                 foldingFlag: false,
                                 count: 0)
            self.data.append(info)
        }
        
        if let data = Item.getDayList(date: Date(), isComplete: true) {
            let info = ItemsInfo(time: data[0].toDay,
                                 isComplete: data[0].isComplete,
                                 items: data,
                                 foldingFlag: false,
                                 count: data.count)
            self.data.append(info)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func getItems(_ indexPath: IndexPath) -> [Item]? {
        return data[safe: indexPath.section]?.items
    }
    
    func getItems(_ section: Int) -> [Item]? {
        return data[safe: section]?.items
    }
    
    func getItem(_ indexPath: IndexPath) -> Item? {
        return data[safe: indexPath.section]?.items[safe: indexPath.row]
    }
    
    func updateCount(_ section: Int) {
        data[safe: section]?.count = (data[safe: section]?.items.count ?? 0)
    }
    
    func updateCount(_ indexPath: IndexPath) {
        data[safe: indexPath.section]?.count = (data[safe: indexPath.section]?.items.count ?? 0)
    }
    
    // MARK: - keyboard notification
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let safeBottom: CGFloat = (window?.safeAreaInsets.bottom ?? 0) + VCHomeTabBar.height

            self.toolBar.isHidden = false
            let height = keyboardHeight - safeBottom + self.toolBar.height
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            let myheight = tableView.frame.height
            let keyboardEndPoint = myheight - keyboardHeight
            
            if let inputActive = self.inputActive,
                let pointInTable = inputActive.superview?.convert(inputActive.frame.origin, to: tableView) {
                let textFieldBottomPoint = pointInTable.y + inputActive.frame.size.height + 20
                if keyboardEndPoint <= textFieldBottomPoint {
                    tableViewContentOffset = tableView.contentOffset.y
//                    print("⚽️ tableView.contentOffset.y: \(tableView.contentOffset.y)")
                    tableView.contentOffset.y = textFieldBottomPoint - keyboardEndPoint
//                    print("⚽️ keyboardWillShow")
//                    print("⚽️ tableView.contentOffset.y: \(tableView.contentOffset.y)")
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentInset = contentInset
                self.toolBarConstraint?.constant = -height
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        inputActive = nil
        guard keyboardHideFlag else { return }
//        print("⚽️ keyboardWillHide")
//        print("⚽️ tableView.contentOffset.y: \(tableView.contentOffset.y)")
        tableView.contentOffset.y = tableViewContentOffset
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.toolBarConstraint?.constant = VCHomeTabBar.height + 50
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.addEditingItem()
            self.toolBar.isHidden = true
        })
    }
    
    @objc func keyboardHide() {
        keyboardHideFlag = true
        view.endEditing(true)
    }
    
    // MARK: - UI
    func setUpUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 30
        tableView.sectionFooterHeight = 0.01
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = Theme.separator
        tableView.separatorStyle = .none
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.backgroundColor = Theme.separator
        toolBar.btnDown.addTarget(self, action: #selector(keyboardHide), for: .touchUpInside)
    }
    
    func displayUI() {
        toolBarConstraint = toolBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: VCHomeTabBar.height + 50)
        
        view.addSubview(tableView)
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            toolBarConstraint!,
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: toolBar.height)
        ])
    }
}
