//
//  VCWeeklyList + UITableView.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import UIKit

extension VCWeeklyList: UITableViewDelegate, UITableViewDataSource {

    // TODO: add Cell 도 추가 할 것
    func registerCell() {
        tableView.register(VCWeeklyListItemCell.self, forCellReuseIdentifier: VCWeeklyListItemCell.identifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCWeeklyListItemCell.identifier, for: indexPath) as! VCWeeklyListItemCell
        
        cell.delegate = self
        cell.selectionStyle = .none
        
        switch (indexPath.row % 3) {
        case 0:
            cell.setUpIncompleteUI("미완료")
        case 1:
            cell.setUpCompleteUI("완료")
        case 2:
            cell.setUpInputUI()
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        switch cell {
        case is VCWeeklyListItemCell:
            let weeklyCell = cell as! VCWeeklyListItemCell
            weeklyCell.checkBox.isOn = !weeklyCell.checkBox.isOn
            if weeklyCell.checkBox.isOn {
                weeklyCell.setCompleted()
            } else {
                weeklyCell.setIncompleted()
            }
            break
        default:
            break
        }
    }
}

extension VCWeeklyList: VCWeeklyListItemCellDelegate {
    func updateCellHeight() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
