//
//  RealmModel.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import Foundation
import RealmSwift

class Memo: Object {
    
    @Persisted var title: String
    @Persisted var writeAt: Date
    @Persisted var content: String
    @Persisted var isPin: Bool
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(title: String, writeAt: Date, content: String, isPin: Bool) {
        self.init()
        
        self.title = title
        self.writeAt = writeAt
        self.content = content
        self.isPin = isPin
        
    }
}
