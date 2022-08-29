//
//  Navigator.swift
//  MyMemo
//
//  Created by bro on 2022/05/24.
//

import UIKit

struct Navigator {
    
    
    func pushViewController<T>(viewController vc: inout T, storyboardName sb: String) {
        
        let vcs = SearchViewController()
        //vcs.iden
        let storyboard = UIStoryboard(name: sb, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: Const.ViewController.ContentViewController) as? T.Type else {
            print("instantiateViewController not Found")
            return
        }
//
//        //메모 수정 화면 변경시 백아이템 타이틀변경
//        navigationItem.backBarButtonItem = UIBarButtonItem(
//            title: "검색", style: .plain, target: nil, action: nil)
//        vc.memo = memo
//        vc.mode = ContentMode.edit
//        self.navigationController?.pushViewController(vc, animated: true )
    }
    
}
