//
//  ViewController.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var memoTableView: UITableView!
    
    var memoList: Results<Memo>! {
        didSet {
            memoTableView.reloadData()
        }
    }
    
    var pinMemoList: Results<Memo>! {
        didSet {
            memoTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBar()
        tableViewConfig()
        loadMemoData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //ViewConroller를 호출시 didLoad에서 호출하면 가장 밑의 뷰 컨트롤러가 무엇인지 특정할 수 없는 오류가 발생
        //DidAppear에서 처음 온 유저를 환영하는 얼럿모양의 화면이 뜨도록 구현
        checkFirstShowed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //작성후 복귀하면서 전체 데이터 리로드
        //loadMemoData()
    }
    
    func initSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        
        self.navigationItem.searchController = searchController
        self.title = "0개의 메모"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true // Large title
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
    
    func tableViewConfig() {
        memoTableView.delegate = self
        memoTableView.dataSource = self
        connectOverviewCell()
    }
    
    func connectOverviewCell() {
        //XIB 파일 연결
        let nibName = UINib(nibName: Const.CustomCell.MemoTableViewCell, bundle: nil)
        memoTableView.register(nibName, forCellReuseIdentifier: Const.CustomCell.MemoTableViewCell)
    }
    
    func setTitleMemoCount() {
        self.title = "\(numberFormatting(number: memoList.count))개의 메모"
    }
    
    func numberFormatting(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: number as NSNumber) ?? "0"
    }
    
    // MARK: - Data Handeling
    func loadMemoData() {
        memoList = MemoRealmManager.shared.loadDatas()
        pinMemoList = MemoRealmManager.shared.searchPinDatas()
        setTitleMemoCount()
    }

    @IBAction func writeBarButtonItemClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Content", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: Const.ViewController.ContentViewController) as? ContentViewController else {
            print("instantiateViewController not Found")
            return
        }
    
        vc.memo = nil
        vc.mode = ContentMode.write
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
}

// MARK: - TableView Delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MemoSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if section == MemoSection.pin.rawValue {
//            return pinMemoList.count
//        } else {
//            return memoList.count
//        }
        
        
        return section == MemoSection.pin.rawValue ? memoList.filter("isPin == true").count : memoList.count
        //return section == MemoSection.pin.rawValue ? (pinMemoList.count <= 5 ? pinMemoList.count : 5) : memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.CustomCell.MemoTableViewCell, for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == MemoSection.pin.rawValue {
            let memo = pinMemoList[indexPath.row]
            cell.configure(memo: memo)
        } else {
            let memo = memoList[indexPath.row]
            cell.configure(memo: memo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == MemoSection.pin.rawValue {
            return "고정된 메모"
        } else {
            return "메모"
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
