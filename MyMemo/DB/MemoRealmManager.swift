//
//  MemoRealmManager.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import Foundation
import RealmSwift

final class MemoRealmManager: RealmRepository {
    static let shared = MemoRealmManager()
    private let localRealm = try! Realm()
    
    private init() {  }

    func loadDatas() -> Results<Memo> {
        return localRealm.objects(Memo.self).sorted(byKeyPath: "writeAt", ascending: false)
    }
        
    func saveData(item: Memo) {
        try! localRealm.write {
            localRealm.add(item)
        }
    }
    
    func deleteData(item: Memo) {
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
    
    func updateData(item: Memo) {
        if let updateItem = localRealm.objects(Memo.self).where({ $0._id == item._id }).first {
            try! localRealm.write {
                updateItem.title = item.title
                updateItem.content = item.content
                updateItem.isPin = item.isPin
                updateItem.writeAt = item.writeAt
            }
        }
    }
    
    func updateData(item: Memo, title: String, content: String, writeAt: Date) {
        try! localRealm.write {
            item.title = item.title
            item.content = item.content
            item.writeAt = item.writeAt
        }
    }
    
    func updatePin(item: Memo) {
        try! localRealm.write {
            item.isPin.toggle()
        }
    }
    
    //5개 제한을 걸어서 보내려 했는데 실패. tableView에서 처리하도록 우선 해결해보도록 할 예정
    func searchPinDatas() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isPin == true")
            //.sorted(byKeyPath: "writeAt", ascending: false)
//        if pinMemoList.count > 5 {
//            var pinList = Results<Memo>()
//            for item in 0..<5 {
//                pinList.add(item)
//            }
//            return pinList
//        }
//        return pinMemoList
    }
    
}
