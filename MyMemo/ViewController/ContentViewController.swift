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
    
    var currentPosition: UITextPosition?
    var currentOffset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        textViewConfig()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //finishData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        finishData()
    }
    
    func initNavigation() {
        shareButton = UIBarButtonItem(image: UIImage(systemName: SystemImage.share.rawValue), style: .plain, target: self, action: #selector(shareButtonClicked))
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
    
    func textViewConfig() {
        memoTextView.delegate = self
        memoTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        memoTextView.scrollIndicatorInsets = memoTextView.textContainerInset
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
            checkInputMemo(title: memoTitle, content: memoContent) ? MemoRealmManager.shared.updateData(item: memo!, title: memoTitle, content: memoContent, writeAt: writeAt) : MemoRealmManager.shared.deleteData(item: memo!)
        }
    }
    
    func checkInputMemo(title: String, content: String) -> Bool {
        //return title != "" && content != "" ? true : false
        return !title.isEmpty ? true : false
    }
    
    func memoTitleConfig() {
        let memoString = memoTextView.text.split(separator: "\n")
        let memoTitle = memoString.count > 0 ? String(memoString[0]) : ""
        
        //NSMutableAttributedString으로 부분적 폰트 적용하기
        let userInputAttributedString = NSMutableAttributedString(string: memoTextView.text)
        userInputAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .bold), range: (memoTextView.text as NSString).range(of: memoTitle))
        memoTextView.attributedText = userInputAttributedString
    }
    
}

extension ContentViewController: UITextViewDelegate {
    
    //처음 작성시에는 괜찮은데 수정시에 타이틀을 수정하려고 하면 커서가 한글자 작성후 컨텐츠로 이동이되는데 해결못함..
    //NSMutableAttributedString 적용전 커서위치를 기억하고 있다가 적용후에 원래 커서 위치로 이동하도록 해서 해결
    func textViewDidChange(_ textView: UITextView) {
        //print("앤 언제 호출되니 textViewDidChange")
        let textRange = textView.selectedTextRange!
        self.currentOffset = textView.offset(from: textView.beginningOfDocument, to: textRange.start)
        self.memoTitleConfig()
        if let newPosition = textView.position(from: textView.beginningOfDocument, offset: self.currentOffset) {
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.initNavigation()
    }
    
    //textViewDidChange 보다 먼저 호출
    //입력하거나 삭제할때마다 호출됨
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //print("앤 언제 호출되니 should")
        //let textRange = textView.selectedTextRange!
        //self.currentOffset = textView.offset(from: textView.beginningOfDocument, to: textRange.start)
        return true
    }
    
}
