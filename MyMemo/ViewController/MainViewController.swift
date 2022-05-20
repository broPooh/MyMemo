//
//  ViewController.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkFirstShowed()
    }

    func checkFirstShowed() {
        let showed = UserDefaultsManager.shared.userDefaults.bool(forKey: Const.UserDefaults.showed)
        
        if !showed {
            print(showed)
            let fistScreen = UIStoryboard(name: Const.Storyboard.FirstScreen, bundle: nil)
            guard let firstViewController = fistScreen.instantiateViewController(withIdentifier: Const.ViewController.FirstScreenViewController) as? FirstScreenViewController else { return }
            firstViewController.modalPresentationStyle = .overFullScreen
            firstViewController.modalTransitionStyle = .crossDissolve
            
            present(firstViewController, animated: true, completion: nil)
        }
    }

}

