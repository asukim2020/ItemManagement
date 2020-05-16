//
//  VCWeeklyList + UITableView.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

enum WeeklyListType {
    case item
    case add
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension VCWeeklyList: UITableViewDelegate, UITableViewDataSource {

    func registerCell() {
        tableView.register(VCWeeklyListItemHedaer.self, forHeaderFooterViewReuseIdentifier: VCWeeklyListItemHedaer.identifier)
        tableView.register(VCWeeklyListItemCell.self, forCellReuseIdentifier: VCWeeklyListItemCell.identifier)
        tableView.register(VCWeeklyListAddCell.self, forCellReuseIdentifier: VCWeeklyListAddCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: VCWeeklyListItemHedaer.identifier) as! VCWeeklyListItemHedaer
        
        guard
            let data = self.data[safe: section]
            else {
                return header
        }
        
        if data.isComplete == true {
            header.setTitle(title: NSLocalizedString("completed_items", comment: "완료된 항목"))
        } else {
            header.setTitle(time: data.time)
        }
        header.delegate = self
        header.section = section
        header.isComplete = data.isComplete
        return header
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: - 필터 기능에 대한 기능 추가 - 현재 1일 기준으로 시작
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = getItems(section) else { return  1 }
        return items.count + (foldingFlag ? 0 : 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case (getItems(indexPath)?.count ?? 0):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: VCWeeklyListAddCell.identifier,
                for: indexPath
            ) as! VCWeeklyListAddCell
            cell.selectionStyle = .none
            return cell

        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: VCWeeklyListItemCell.identifier,
                for: indexPath
            ) as! VCWeeklyListItemCell
            guard let item = getItem(indexPath) else { return  cell }
            
            cell.delegate = self
            cell.selectionStyle = .none
            
            cell.checkBox.isOn = item.isComplete
            cell.indexPath = indexPath
            
            if item.key == 0 || editIndex == indexPath {
                cell.setUpInputUI(item.title)
                self.editIndex = indexPath
                cell.tvWrite?.becomeFirstResponder()
            } else if item.isComplete {
                cell.setUpCompleteUI(item.title)
            } else {
                cell.setUpIncompleteUI(item.title)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        keyboardHideFlag = false
        
        switch cell {
        case is VCWeeklyListItemCell:
            inputActive = cell as? VCWeeklyListItemCell
            addEditingItem() { [weak self] in
                self?.editIndex = indexPath
                tableView.reloadRows(at: [indexPath], with: .automatic)
                let weeklyCell = tableView.cellForRow(at: indexPath) as! VCWeeklyListItemCell
                weeklyCell.tvWrite?.becomeFirstResponder()
            }

        case is VCWeeklyListAddCell:
            addEditingItem() { [weak self] in
                tableView.beginUpdates()
                self?.data[safe: indexPath.section]?.items.append(Item())
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        default:
            break
        }
    }
    
    func addEditingItem(complete: (() -> ())? = nil) {
        guard let indexPath = editIndex,
            let item = getItem(indexPath) else {
                complete?()
                return
        }
        
        if item.key != 0 {
            editIndex = nil
            tableView.reloadRows(at: [indexPath], with: .automatic)
            complete?()
        } else {
            Item.add(item: item).subscribe(
                onNext: { [weak self] item in
                    self?.editIndex = nil
                    var items = self?.getItems(indexPath)
                    items?[indexPath.row] = item
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    complete?()
                },
                onError: { error in
                    // TODO: - 예외처리 다이얼로그 띄우거나 toast 메시지 띄우기
            }).dispose()
        }
    }
}

// MARK:- VCWeeklyListItemHedaerDelegate
extension VCWeeklyList: VCWeeklyListItemHedaerDelegate {
    func foldingSection(section: Int, isComplete: Bool) {
        guard let items = getItems(section) else { return }
        
        tableView.beginUpdates()
        foldingFlag = true
        var indexPaths: [IndexPath] = []
        for (idx, _) in items.enumerated() {
            indexPaths.append(IndexPath(row: idx, section: section))
        }
        indexPaths.append(IndexPath(row: indexPaths.count, section: section))
        
        self.data[safe: section]?.items.removeAll()
        tableView.deleteRows(at: indexPaths, with: .top)
        tableView.endUpdates()
    }
    
    func unFoldingSection(section: Int, isComplete: Bool) {
        guard let data = Item.getDayList(date: Date()) else { return }
        guard var items = getItems(section) else { return }

        tableView.beginUpdates()
        foldingFlag = false
        
        self.data[safe: section]?.items = data
        items = data
        var indexPaths: [IndexPath] = []
        for (idx, _) in items.enumerated() {
            indexPaths.append(IndexPath(row: idx, section: 0))
        }
        indexPaths.append(IndexPath(row: indexPaths.count, section: 0))
        
        tableView.insertRows(at: indexPaths, with: .top)
        tableView.endUpdates()
    }
    
    
}

// MARK: - VCWeeklyListItemCellDelegate
extension VCWeeklyList: VCWeeklyListItemCellDelegate {
    func updateCellHeight() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func textViewDidChange(title: String, indexPath: IndexPath) {
        guard let item = getItem(indexPath) else { return }
        if item.key == 0 {
            item.title = title
            editIndex = indexPath
        } else {
            guard let realm = try? Realm() else { return }
            try? realm.write {
                item.title = title
            }
        }
    }
    
    func updateIsComplete(isComplete: Bool, indexPath: IndexPath) {
        guard let realm = try? Realm() else { return }
        try? realm.write {
            self.data[safe: indexPath.section]?.items[safe: indexPath.row]?.isComplete = isComplete
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
