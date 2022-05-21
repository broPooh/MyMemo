//
//  ViewController.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import UIKit
import RealmSwift
import SwiftUI
import Toast

class MainViewController: UIViewController {

    @IBOutlet weak var memoTableView: UITableView!
    
    var memoList: Results<Memo>!
    var pinList: Results<Memo>! {
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
        loadMemoData()
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
        connectMemoCell()
        connectMemoHeaderView()
    }
    
    func connectMemoCell() {
        //XIB 파일 연결
        let nibName = UINib(nibName: Const.CustomCell.MemoTableViewCell, bundle: nil)
        memoTableView.register(nibName, forCellReuseIdentifier: Const.CustomCell.MemoTableViewCell)
    }
    
    func connectMemoHeaderView() {
        //XIB 파일 연결
        let nibName = UINib(nibName: Const.CustomCell.MemoHeaderTableView, bundle: nil)
        memoTableView.register(nibName, forHeaderFooterViewReuseIdentifier: Const.CustomCell.MemoHeaderTableView)
        //memoTableView.register(nibName, forCellReuseIdentifier: Const.CustomCell.MemoHeaderView)
    }
    
    func setTitleMemoCount() {
        self.title = "\(numberFormatting(number: memoList.count + pinList.count))개의 메모"
    }
    
    func numberFormatting(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: number as NSNumber) ?? "0"
    }
    
    // MARK: - Data Handeling
    func loadMemoData() {
        let results = MemoRealmManager.shared.loadDatas()
        memoList = results.filter("isPin == false")
        pinList = results.filter("isPin == true")
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
        
        //memoList.count는 Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value가 발생하지 않는데
        //pinList.count는 왜 Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value가 발생하지..
        //didSet에서 TableView를 리로드해주었었는데 이 부분에서 에러가 발생한것 같다. -> 정확하게 물어보기.
        
        //return section == MemoSection.pin.rawValue ? pinList.count : memoList.count
        return section == MemoSection.pin.rawValue ? (pinList.count <= 5 ? pinList.count : 5) : memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.CustomCell.MemoTableViewCell, for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
        
        let memo = indexPath.section == MemoSection.pin.rawValue ? pinList[indexPath.row] : memoList[indexPath.row]
        cell.configure(memo: memo)
//        if indexPath.section == MemoSection.pin.rawValue && pinList.count > 0 {
//            cell.configure(memo: memo)
//        } else if indexPath.section == MemoSection.normal.rawValue && memoList.count > 0 {
//            cell.configure(memo: memo)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //커스텀 섹션 추가후 서치바가 처음 앱을 실행시 나타나지 않다가 스크롤시 나타나는 현상이 생김
    //에러를 잡아야 하는 상황임.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Const.CustomCell.MemoHeaderTableView) as? MemoHeaderTableView else { return UITableViewHeaderFooterView() }
        
        let sectionTitle = section == MemoSection.pin.rawValue ? "고정된 메모" : "메모"
        header.titleLabel.text = sectionTitle
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == MemoSection.pin.rawValue {
            return pinList.count != 0 ? 48 : 0
        } else {
            return 48
        }
    }
    
    //왼쪽 스와이프시 핀 모양 나오도록
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let updateMemo = indexPath.section == MemoSection.pin.rawValue ? pinList[indexPath.row] : memoList[indexPath.row]
        let pinAction = UIContextualAction(style: .normal, title: "pin", handler: { action, view, completionHaldler in
            
            if !updateMemo.isPin && self.pinList.count >= 5 {
                self.view.makeToast("고정은 5개까지만 가능합니다!")
                completionHaldler(true)
                return
            }
            MemoRealmManager.shared.updatePin(item: updateMemo)
            
            self.loadMemoData()
            completionHaldler(true)
        })
        
        pinAction.backgroundColor = .systemOrange
        pinAction.image = indexPath.section == MemoSection.pin.rawValue ? UIImage(systemName: "pin.slash.fill") : UIImage(systemName: "pin.fill")
        
        return UISwipeActionsConfiguration(actions: [pinAction])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .none:
            print(#function)
        case .delete:
            let deleteItem = indexPath.section == MemoSection.pin.rawValue ? pinList[indexPath.row] : memoList[indexPath.row]
            MemoRealmManager.shared.deleteData(item: deleteItem)
            loadMemoData()
//            if indexPath.section == MemoSection.pin.rawValue {
//                let deleteItem = pinList[indexPath.row]
//                MemoRealmManager.shared.deleteData(item: deleteItem)
//                loadMemoData()
//            } else {
//                let deleteItem = memoList[indexPath.row]
//                MemoRealmManager.shared.deleteData(item: deleteItem)
//                loadMemoData()
//            }
        case .insert:
            print(#function)
        @unknown default:
            print(#function)
        }
    }
    
    //클릭시 수정화면 전환
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let sb = UIStoryboard(name: "Content", bundle: nil)
        //let vc = sb.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
        let sb = UIStoryboard(name: "Content", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: Const.ViewController.ContentViewController) as? ContentViewController else {
            print("instantiateViewController not Found")
            return
        }
    
        vc.memo = indexPath.section == MemoSection.pin.rawValue ? pinList[indexPath.row] : memoList[indexPath.row]
        vc.mode = ContentMode.edit
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
}


// MARK: - UISearchResultsUpdating Delegate
extension MainViewController: UISearchResultsUpdating {
    
    
  
  func updateSearchResults(for searchController: UISearchController) {
    
      guard let searchText = searchController.searchBar.text else { return }
            print(searchText)
  }
    
}
