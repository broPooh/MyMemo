//
//  UserDefaultsManager.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    let userDefaults = UserDefaults.standard
    
    private init() { }
}
