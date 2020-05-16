//
//  Item.swift
//  ItemManagement
//
//  Created by Asu on 2020/05/06.
//  Copyright © 2020 Asu. All rights reserved.
//

import RealmSwift
import RxCocoa
import RxSwift

@objcMembers class Item: Object {
    
    // 생성 시간
    dynamic var key: Int64 = 0
    
    // 제목
    dynamic var title: String = ""
    
    // 완료 여부
    dynamic var isComplete: Bool = false
    
    // 정렬 순서
    dynamic var order: Int = -1
    
    // 지정한 날짜
    dynamic var toDay: TimeInterval = 0.0
    
    override static func primaryKey() -> String? {
        return "key"
    }
    
    // MARK: - funcsion
    static func add(item: Item, date: Date = Date()) -> Observable<Item> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                if item.key == 0 {
                    item.key = Int64(date.timeIntervalSince1970 * 1000)
                    item.order = (realm.objects(Item.self).sorted(byKeyPath: "order", ascending: false).first?.order ?? 0) + 1
                    item.toDay = date.startOfDay.timeIntervalSince1970
                }
                
                try realm.write {
                    realm.add(item, update: .all)
                    try realm.commitWrite()
                    observer.on(.next(item))
                    observer.on(.completed)
                }
                
            } catch {
                observer.on(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func getDayList(date: Date, isComplete: Bool = false) -> [Item]? {
        do {
            let startOfDay = date.startOfDay.timeIntervalSince1970
            let endOfDay = date.endOfDay.timeIntervalSince1970
            let realm = try Realm()
            let list = realm.objects(Item.self).filter(
                "%@ <= toDay AND toDay <= %@ AND isComplete == %@",
                startOfDay,
                endOfDay,
                isComplete
            )
            
            if list.count == 0 {
                return nil
            }
            
            var itemList: [Item] = []
            itemList.append(contentsOf: list)
            return itemList
        } catch {
            return nil
        }
    }
    
    static func removeAll() -> Observable<Results<Item>> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let items = realm.objects(Item.self)
                
                try realm.write {
                    realm.delete(items)
                    observer.on(.next(items))
                    observer.on(.completed)
                }
                
            } catch {
                observer.on(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
