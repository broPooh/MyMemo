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
        initSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkFirstShowed()
    }
    
    func initSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        
        self.navigationItem.searchController = searchController
        self.title = "0개의 메모"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true // Large title로 하고싶을 때 추가
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


// MARK: - UISearchResultsUpdating Delegate
extension MainViewController: UISearchResultsUpdating {
    
    
  
  func updateSearchResults(for searchController: UISearchController) {
    
      guard let searchText = searchController.searchBar.text else { return }
            print(searchText)
  }
    
}
