//
//  RealmRepository.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import Foundation
import RealmSwift
//@Persisted var title: String
//@Persisted var writeAt: Date
//@Persisted var content: String
//@Persisted var isPin: Bool
//
//@Persisted(primaryKey: true) var _id: ObjectId

protocol RealmRepository {
    
    func loadDatas() -> Results<Memo>
    func saveData(item: Memo)
    func deleteData(item: Memo)
    func updateData(item: Memo)
    func searchPinDatas() -> Results<Memo>
    
}
