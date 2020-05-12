//
//  VCWeeklyList.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/04.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCWeeklyList: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let toolBar = ToolBar()
    var toolBarConstraint: NSLayoutConstraint?
    // TODO: - 2차원 배열로 변경할 것 - 7일치 데이터 받아아도록
    var data: [Item] = []
    var editIndex: IndexPath?
    var keyboardHideFlag: Bool = false
    var foldingFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        
        setUpUI()
        displayUI()
        registerCell()
        
        if let data = Item.getDayList(date: Date()) {
            self.data = data
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
    
    // MARK: - keyboard notification
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let safeBottom: CGFloat = (window?.safeAreaInsets.bottom ?? 0) + VCHomeTabBar.height

            self.toolBar.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - safeBottom + self.toolBar.height, right: 0)
                self.toolBarConstraint?.constant = -(keyboardHeight - safeBottom + self.toolBar.height)
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        guard keyboardHideFlag else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.toolBarConstraint?.constant = VCHomeTabBar.height + 50
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.addItem()
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
