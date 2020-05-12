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
        tableView.register(VCWeeklyListItemCell.self, forCellReuseIdentifier: VCWeeklyListItemCell.identifier)
        tableView.register(VCWeeklyListAddCell.self, forCellReuseIdentifier: VCWeeklyListAddCell.identifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case data.count:
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
            cell.delegate = self
            cell.selectionStyle = .none
            
            let data = self.data[indexPath.row]
            cell.checkBox.isOn = data.isComplete
            cell.indexPath = indexPath
            
            if data.key == 0 || editIndex == indexPath {
                cell.setUpInputUI(data.title)
                self.editIndex = indexPath
                cell.tvWrite?.becomeFirstResponder()
            } else if data.isComplete {
                cell.setUpCompleteUI(data.title)
            } else {
                cell.setUpIncompleteUI(data.title)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        keyboardHideFlag = false
        
        switch cell {
        case is VCWeeklyListItemCell:
            addItem() {
                self.editIndex = indexPath
                tableView.reloadRows(at: [indexPath], with: .automatic)
                let weeklyCell = tableView.cellForRow(at: indexPath) as! VCWeeklyListItemCell
                weeklyCell.tvWrite?.becomeFirstResponder()
            }

        case is VCWeeklyListAddCell:
            addItem() {
                tableView.beginUpdates()
                self.data.append(Item())
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        default:
            break
        }
    }
    
    func addItem(complete: (() -> ())? = nil) {
        guard let indexPath = editIndex else {
            complete?()
            return
        }
        
        let item = data[indexPath.row]
        if item.key != 0 {
            editIndex = nil
            tableView.reloadRows(at: [indexPath], with: .automatic)
            complete?()
        } else {
            Item.add(item: item).subscribe(
                onNext: { [weak self] item in
                    self?.editIndex = nil
                    self?.data[indexPath.row] = item
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    complete?()
                },
                onError: { error in
                    // TODO: - 예외처리 다이얼로그 띄우거나 toast 메시지 띄우기
            }).dispose()
        }
    }
}

// MARK: - VCWeeklyListItemCellDelegate
extension VCWeeklyList: VCWeeklyListItemCellDelegate {
    func updateCellHeight() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func textViewDidChange(title: String, indexPath: IndexPath) {
        let data = self.data[indexPath.row]
        if data.key == 0 {
            data.title = title
            editIndex = indexPath
        } else {
            guard let realm = try? Realm() else { return }
            try? realm.write {
                data.title = title
            }
        }
    }
    
    func updateIsComplete(isComplete: Bool, indexPath: IndexPath) {
        guard let realm = try? Realm() else { return }
        try? realm.write {
            self.data[indexPath.row].isComplete = isComplete
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

// MARK: - Scroll Event
extension VCWeeklyList {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        view.endEditing(true)
//    }
}
