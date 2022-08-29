//
//  MemoRealmManager.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import Foundation
import RealmSwift

enum RealmFilter: String {
    case isPin = "isPin == true"
    case noPin = "isPin == false"
}

final class MemoRealmManager: RealmRepository {
    static let shared = MemoRealmManager()
    //private let localRealm = try! Realm()
    
    //let realm = Realm()
    
    private init() {  }

    func loadDatas() -> Results<Memo> {
        let localRealm = try! Realm()
        return localRealm.objects(Memo.self).sorted(byKeyPath: "writeAt", ascending: false)
    }
        
    func saveData(item: Memo) {
        print("메모 저장")
        let localRealm = try! Realm()
        do {
            try localRealm.write {
                localRealm.add(item)
            }
        } catch {
            print("Error save : \(error)")
        }
        
//        try! localRealm.write {
//            localRealm.add(item)
//        }
    }
    
    func deleteData(item: Memo) {
        let localRealm = try! Realm()
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
            print("Error Delete : \(error)")
        }
//        try! localRealm.write {
//            localRealm.delete(item)
//        }
    }
    
    //tranjection Error 발생, 어떻게 해결해야할지 몰라서 하나씩 꺼내서 다 지정하도록 변경
    func updateData(item: Memo) {
        let localRealm = try! Realm()
        if let updateItem = localRealm.objects(Memo.self).where({ $0._id == item._id }).first {
            do {
                try localRealm.write {
                    updateItem.title = item.title
                    updateItem.content = item.content
                    updateItem.isPin = item.isPin
                    updateItem.writeAt = item.writeAt
                }
            } catch {
                print("Error Update : \(error)")
            }
//            try! localRealm.write {
//                updateItem.title = item.title
//                updateItem.content = item.content
//                updateItem.isPin = item.isPin
//                updateItem.writeAt = item.writeAt
//            }
        }
    }
    
    func updateData(item: Memo, title: String, content: String?, writeAt: Date) {
        let localRealm = try! Realm()
        do {
            try localRealm.write {
                item.title = title
                item.content = content
                item.writeAt = writeAt
            }
        } catch {
            print("Error Update : \(error)")
        }
//        try! localRealm.write {
//            item.title = title
//            item.content = content
//            item.writeAt = writeAt
//        }
    }
    
    func updatePin(item: Memo) {
        let localRealm = try! Realm()
        do {
            try localRealm.write {
                item.isPin.toggle()
            }
        } catch {
            print("Error UpdatePin : \(error)")
        }
//        try! localRealm.write {
//            item.isPin.toggle()
//        }
    }
    
    //5개 제한을 걸어서 보내려 했는데 실패. tableView에서 처리하도록 우선 해결해보도록 할 예정
//    func searchPinDatas() -> Results<Memo> {
//        return localRealm.objects(Memo.self).filter("isPin == true")
//            //.sorted(byKeyPath: "writeAt", ascending: false)
//        if pinMemoList.count > 5 {
//            var pinList = Results<Memo>()
//            for item in 0..<5 {
//                pinList.add(item)
//            }
//            return pinList
//        }
//        return pinMemoList
//    }
    
    func searchMemoData(searchText: String) -> Results<Memo> {
        let localRealm = try! Realm()
        return localRealm.objects(Memo.self).where({
            $0.title.contains(searchText) || $0.content.contains(searchText)
        })
    }
    
    func loadDataWithFileter(filter: RealmFilter) -> Results<Memo> {
        let localRealm = try! Realm()
        return localRealm.objects(Memo.self).filter(filter.rawValue).sorted(byKeyPath: "writeAt", ascending: false)
    }
    
    func loadDataWithFileter(isPin: Bool) -> Results<Memo> {
        let localRealm = try! Realm()
        return localRealm.objects(Memo.self).where { $0.isPin == isPin }.sorted(byKeyPath: "writeAt", ascending: false)
    }
    
}
