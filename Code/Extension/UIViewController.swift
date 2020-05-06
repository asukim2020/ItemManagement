//
//  UIViewController.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/05.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension UIViewController {
    static var separatorSize: CGFloat = 0.7
    
    func setTopBarColor() {
        clearStatusBarColor()
        clearNavigationBarColor()
        
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Theme.bar
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Theme.separator
        
        view.addSubview(v)
        view.addSubview(separator)
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: view.topAnchor),
            v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            separator.bottomAnchor.constraint(equalTo: v.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: UIViewController.separatorSize)
        ])
    }
    
    func clearStatusBarColor() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        let statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let statusbarView = UIView()
        statusbarView.backgroundColor = .clear
        view.addSubview(statusbarView)
        
        statusbarView.translatesAutoresizingMaskIntoConstraints = false
        statusbarView.heightAnchor
            .constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor
            .constraint(equalTo: view.topAnchor).isActive = true
        statusbarView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func clearNavigationBarColor() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

