//
//  VCWeeklyList.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/04.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

class VCWeeklyList: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        
        setUpUI()
        displayUI()
        registerCell()
    }
    
    func setUpUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = Theme.separator
    }
    
    func displayUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
