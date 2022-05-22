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

        initData()
        memoTextView.delegate = self
        
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
    
    func hiddenNavigationItems() {
        view.endEditing(true)
        navigationItem.rightBarButtonItems = nil
    }
    
    func initData() {
        if mode == ContentMode.edit {
            guard let memoResult = memo else { return }
            memoTextView.text = memoResult.title + "\n" + memoResult.content
            memoTitleConfig()
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
        finishData()
        hiddenNavigationItems()
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
            print("\(checkInputMemo(title: memoTitle, content: memoContent))")
            checkInputMemo(title: memoTitle, content: memoContent) ? MemoRealmManager.shared.updateData(item: memo!, title: memoTitle, content: memoContent, writeAt: writeAt) : MemoRealmManager.shared.deleteData(item: memo!)
        }
    }
    
    func checkInputMemo(title: String?, content: String?) -> Bool {
        return title != "" && content != "" ? true : false
    }
    
    func memoTitleConfig() {
        let memoString = memoTextView.text.split(separator: "\n")
        let memoTitle = memoString.count > 0 ? String(memoString[0]) : ""
        
        //NSMutableAttributedString으로 부분적 폰트 적용하기
        let userInputAttributedString = NSMutableAttributedString(string: memoTextView.text)
        userInputAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: .bold), range: (memoTextView.text as NSString).range(of: memoTitle))
        memoTextView.attributedText = userInputAttributedString
    }
    
}

extension ContentViewController: UITextViewDelegate {
    
    //처음 작성시에는 괜찮은데 수정시에 타이틀을 수정하려고 하면 커서가 한글자 작성후 컨텐츠로 이동이되는데 해결못함..
    func textViewDidChange(_ textView: UITextView) {
        self.memoTitleConfig()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.initNavigation()
    }
    
}
