//
//  MemoHeaderTableView.swift
//  MyMemo
//
//  Created by bro on 2022/05/21.
//

import UIKit

class MemoHeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelConfig()
        backgroundColor = .red
    }

    func labelConfig() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
}
