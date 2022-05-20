//
//  FirstScreenViewController.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import UIKit

class FirstScreenViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfig()

    }
    
    func viewConfig() {
        containerViewConfig()
        labelConfig()
        buttonConfig()
    }
    
    func containerViewConfig() {
        containerView.backgroundColor = .black
        containerView.layer.cornerRadius = 10
    }
    
    func labelConfig() {
        titleLabel.text = "처음 오셨군요!\n환영합니다:)\n\n당신만의 메모를 작성하고\n관리해보세요!"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.backgroundColor = .black
        titleLabel.numberOfLines = 0
    }
    
    func buttonConfig() {
        okButton.setTitle("확인", for: .normal)
        okButton.titleLabel?.textColor = .white
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        okButton.backgroundColor = .orange
        okButton.tintColor = .white
        okButton.layer.cornerRadius = 10
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        UserDefaultsManager.shared.userDefaults.set(true, forKey: Const.UserDefaults.showed)
        self.dismiss(animated: true, completion: nil)
    }
}
