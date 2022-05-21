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
    
    let shareButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
    let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonClicked))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigation()
        initData()
        
    }
    
    func initNavigation() {
        navigationItem.rightBarButtonItems = [finishButton, shareButton]
    }
    
    func initData() {
        if mode == ContentMode.edit {
            finishButton.title = "수정"
            guard let memoResult = memo else { return }
            memoTextView.text = memoResult.title + "\n" + memoResult.content
            
        } else {
            finishButton.title = "완료"
            memoTextView.becomeFirstResponder()
        }
    }
    
    @objc func shareButtonClicked() {
        
        var shareText: [Any] = []
        
        if let text = memoTextView.text {
            shareText.append(text)
        
            let activityViewController = UIActivityViewController(activityItems: shareText, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
        
            self.present(activityViewController, animated: true, completion: nil)
            
        } else {
            print("공유할 내용이 없습니다.")
        }
    }
    
    @objc func finishButtonClicked() {
        guard let userInputText = memoTextView.text else { return }
        
        let memoString = userInputText.split(separator: "\n")
        let memoTitle = String(memoString[0])
        let memoContent = String(memoString[1])
        let writeAt = Date()

        let memo = Memo(title: memoTitle, content: memoContent, writeAt: writeAt)
        if mode == ContentMode.write {
            MemoRealmManager.shared.saveData(item: memo)
        } else {
            MemoRealmManager.shared.updateData(item: memo)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
