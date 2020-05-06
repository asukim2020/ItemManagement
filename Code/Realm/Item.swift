//
//  Item.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import RealmSwift

class Item: Object {
    
    // 생성 시간
    dynamic var key: TimeInterval = 0.0
    
    // 제목
    dynamic var title: String = ""
    
    // 완료 여부
    dynamic var isComplete: Bool = false
    
    // 정렬 순서
    dynamic var order: Int = -1
    
    // 지정한 날짜
    dynamic var date: Date = Date()
}
