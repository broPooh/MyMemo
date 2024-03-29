//
//  SearchViewController.swift
//  MyMemo
//
//  Created by bro on 2022/05/21.
//

import UIKit
import RealmSwift

//이 Delgate를 통해 검색후 핀, 삭제시 Main화면 테이블뷰 갱신처리
//이 Delgate를 통해 검색후 클릭시 화면전환 처리
protocol SearchDelegate {
    func reloadTableView()
    func presentSearchResult(memo: Memo)
}

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTableView: UITableView!
    var searchText: String = ""
    
    var searchDelegate: SearchDelegate?
    
    var totalPinMemo: Results<Memo>!
    var searchResult: Results<Memo>! {
        didSet {
            searchTableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        tableViewConfig()
        searchBarConfig()
        loadData(search: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Search viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Search viewWillDIsAppear")
        searchDelegate?.reloadTableView()
    }
    
    func tableViewConfig() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        connectMemoCell()
        connectMemoHeaderView()
    }
    
    func connectMemoCell() {
        //XIB 파일 연결
        let nibName = UINib(nibName: Const.CustomCell.MemoTableViewCell, bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: Const.CustomCell.MemoTableViewCell)
    }
    
    func connectMemoHeaderView() {
        //XIB 파일 연결
        let nibName = UINib(nibName: Const.CustomCell.MemoHeaderTableView, bundle: nil)
        searchTableView.register(nibName, forHeaderFooterViewReuseIdentifier: Const.CustomCell.MemoHeaderTableView)
    }
    
    func searchBarConfig() {
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.placeholder = "검색"
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        self.navigationItem.hidesSearchBarWhenScrolling = false //스크롤시 서치바 사라지지 않도록 설정
        self.navigationController?.navigationBar.prefersLargeTitles = true // Large title
    }
    
    
    func loadData(search: String) {
        //let result = MemoRealmManager.shared.loadDatas()
        //totalPinMemo = result.filter("isPin == true")
        totalPinMemo = MemoRealmManager.shared.loadDataWithFileter(filter: .isPin)
        //searchResult = searchMemoData(totalMemo: result, searchText: search)
        searchResult = MemoRealmManager.shared.searchMemoData(searchText: search)
    }
    
//    func searchMemoData(totalMemo: Results<Memo> ,searchText: String) -> Results<Memo> {
//        return totalMemo.where({
//            $0.title.contains(searchText) || $0.content.contains(searchText)
//        })
//    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.CustomCell.MemoTableViewCell, for: indexPath) as? MemoTableViewCell else { return UITableViewCell() }
        
        let memo = searchResult[indexPath.row]
        
        //NSMutableAttributedString으로 부분적 색상변경 적용하기
        cell.configure(memo: memo, searchText: searchText)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(MemoTableHeight.content.rawValue)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Const.CustomCell.MemoHeaderTableView) as? MemoHeaderTableView else { return UITableViewHeaderFooterView() }
        header.titleLabel.text = "\(searchResult.count)개 찾음"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(MemoTableHeight.header.rawValue)
    }
    
    
    //왼쪽 스와이프시 핀 모양 나오도록
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateMemo = searchResult[indexPath.row]
        let pinAction = UIContextualAction(style: .normal, title: "pin") { action, view, completionHaldler in
                        
            if !updateMemo.isPin && self.totalPinMemo.count >= 5 {
                //self.view.makeToast("고정은 5개까지만 가능합니다!")
                self.view.makeToast("고정은 5개까지만 가능합니다!", duration: 1.0, position: .center)
                completionHaldler(true)
                return
            }
            MemoRealmManager.shared.updatePin(item: updateMemo)
            self.loadData(search: self.searchText)
            completionHaldler(true)
        }
        
        pinAction.backgroundColor = .systemOrange
        pinAction.image = updateMemo.isPin ? UIImage(systemName: SystemImage.slashPin.rawValue) : UIImage(systemName: SystemImage.pin.rawValue)
        
        return UISwipeActionsConfiguration(actions: [pinAction])
    }
    
    //오른쪽 스와이프시 삭제 모양 나오도록
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("삭제")
        let deleteMemo = searchResult[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
          
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                MemoRealmManager.shared.deleteData(item: deleteMemo)
                self.loadData(search: self.searchText)
                self.searchDelegate?.reloadTableView()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            self.presentAlert(title: "삭제하시겠습니까?", message: "", alertActions: ok, cancel)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: SystemImage.trash.rawValue)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    //클릭시 수정화면 전환
    // 클릭은 한거 같은데 왜 화면 전환이 안되지.?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchDelegate?.presentSearchResult(memo: searchResult[indexPath.row])
    }
    
}


// MARK: - UISearchResultsUpdating Delegate
extension SearchViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
      guard let searchText = searchController.searchBar.text else { return }
      self.searchText = searchText
      self.loadData(search: searchText)
  }
        
}
