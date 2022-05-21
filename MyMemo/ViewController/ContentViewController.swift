//
//  ContentViewController.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var memoTextView: UITextView!
    
    var memo: Memo?
    var mode: ContentMode?
    
//    var shareButton: UIBarButtonItem = {
//        return UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: ContentViewController.self, action: #selector(shareButtonClicked))
//    }()
//    lazy var finishButton: UIBarButtonItem = {
//        return UIBarButtonItem(title: "완료", style: .plain, target: ContentViewController.self, action: #selector(finishButtonClicked))
//    }()
    
    var shareButton: UIBarButtonItem?
    var finishButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigation()
        initData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        finishData()
    }
    
    func initNavigation() {
        shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonClicked))
        navigationItem.rightBarButtonItems = [finishButton!, shareButton!]
    }
    
    func initData() {
        if mode == ContentMode.edit {
            guard let memoResult = memo else { return }
            memoTextView.text = memoResult.title + "\n" + memoResult.content
        } else {
            memoTextView.becomeFirstResponder()
        }
    }
    
    @objc func shareButtonClicked() {
        if let userInputText = memoTextView.text {
                    
            let activityViewController = UIActivityViewController(activityItems: [userInputText], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            print("공유할 내용이 없습니다.")
        }
    }
    
    @objc func finishButtonClicked() {
        //finishData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func finishData() {
        guard let userInputText = memoTextView.text else { return }
        
        let memoString = userInputText.split(separator: "\n")
        let memoTitle = memoString.count > 0 ? String(memoString[0]) : ""
        let memoContent = memoString.count > 1 ? String(memoString[1]) : ""
        let writeAt = Date()
        
        
        if mode == ContentMode.write {
            memo = Memo(title: memoTitle, content: memoContent, writeAt: writeAt)
            checkInputMemo(title: memoTitle, content: memoContent) ? MemoRealmManager.shared.saveData(item: memo!) : print("데이터 없음"); return
        } else {
            checkInputMemo(title: memoTitle, content: memoContent) ? MemoRealmManager.shared.updateData(item: memo!, title: memoTitle, content: memoContent, writeAt: writeAt) : MemoRealmManager.shared.deleteData(item: memo!)
        }
    }
    
    func checkInputMemo(title: String?, content: String?) -> Bool {
        return title != "" && content != "" ? true : false
    }
    
}
