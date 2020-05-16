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
        header.foldingFlag = data.foldingFlag
        return header
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = getItems(section) else { return  1 }
        if let data = self.data[safe: section] {
            if data.isComplete {
                return items.count
            }
        }
        return items.count + ((self.data[safe: section]?.foldingFlag ?? false) ? 0 : 1)
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
                inputActive = cell
                cell.setUpInputUI(item.title)
                self.editIndex = indexPath
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                guard let removeData = self.data[safe: indexPath.section]?.items.remove(at: indexPath.row) else {
                    completionHandler(true)
                    return
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                guard let realm = try? Realm() else { return }
                try? realm.write {
                    realm.delete(removeData)
                }
                
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = UIColor(hexString: "#FA5858")
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
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
                    print("⚽️ error: \(error)")
                    // TODO: - 예외처리 다이얼로그 띄우거나 toast 메시지 띄우기
            }).dispose()
        }
    }
}

// MARK:- VCWeeklyListItemHedaerDelegate
extension VCWeeklyList: VCWeeklyListItemHedaerDelegate {
    func foldingSection(section: Int, isComplete: Bool) {
        toolBar.isHidden = true
        self.data[safe: section]?.foldingFlag = true
        self.data[safe: section]?.items.removeAll()
        tableView.reloadSections([section], with: .automatic)
    }
    
    func unFoldingSection(section: Int, isComplete: Bool) {
        if let data = Item.getDayList(date: Date(), isComplete: isComplete) {
            self.data[safe: section]?.items = data
        } else {
            self.data[safe: section]?.items = []
        }
        self.data[safe: section]?.foldingFlag = false
        tableView.reloadSections([section], with: .automatic)
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
        self.toolBar.isHidden = true
        guard let realm = try? Realm() else { return }
        try? realm.write { [weak self] in
            guard let self = self else { return }
            self.data[safe: indexPath.section]?.items[safe: indexPath.row]?.isComplete = isComplete
            updateUIIsComplete(isComplete: isComplete, indexPath: indexPath)
        }
    }
    
    func updateUIIsComplete(isComplete: Bool, indexPath: IndexPath) {
        guard let removeData = self.data[safe: indexPath.section]?.items.remove(at: indexPath.row) else { return }
        
        if isComplete {
            // 완료로 변경되는 경우
            if (self.data[safe: indexPath.section + 1]?.isComplete ?? false) {
                // 섹션이 있는 경우
                self.data[safe: indexPath.section + 1]?.items.append(removeData)
                self.data[safe: indexPath.section + 1]?.items =
                    self.data[safe: indexPath.section + 1]!.items.sorted { $0.order < $1.order }
                DispatchQueue.main.async {
                    self.tableView.reloadSections([indexPath.section, indexPath.section + 1], with: .automatic)
                }
            } else {
                // 섹션이 없는 경우
                let info = ItemsInfo(time: removeData.toDay,
                                     isComplete: removeData.isComplete,
                                     items: [removeData],
                                     foldingFlag: false)
                
                self.data.insert(info, at: indexPath.section + 1)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            // 미완료로 변경된 경우
            self.data[safe: indexPath.section - 1]?.items.append(removeData)
            self.data[safe: indexPath.section - 1]?.items =
                self.data[safe: indexPath.section - 1]!.items.sorted { $0.order < $1.order }
            DispatchQueue.main.async {
                self.tableView.reloadSections([indexPath.section - 1, indexPath.section], with: .automatic)
            }
        }
    }
}
