//
//  MemoTableViewCell.swift
//  MyMemo
//
//  Created by bro on 2022/05/20.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .lightGray
    }
    
    func configure(memo: Memo, searchText: String) {
        //titleLabel.text = memo.title
        //dateLabel.text = memo.writeAt.toString()
        contentLabel.text = memo.content ?? "추가 텍스트 없음"
        
        changeColor(memo: memo, searchText: searchText)
    }
    
    func configure(memo: Memo) {
        titleLabel.text = memo.title
        dateLabel.text = memo.writeAt.toString()
        contentLabel.text = memo.content ?? "추가 텍스트 없음"
    }
    
    func changeColor(memo: Memo, searchText: String) {
        let titleAttributedString = NSMutableAttributedString(string: memo.title)
        let contentAttributedString = NSMutableAttributedString(string: memo.content ?? "")
        
        titleAttributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: (memo.title as NSString).range(of: searchText))
        contentAttributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: ((memo.content ?? "") as NSString).range(of: searchText))
        titleLabel.attributedText = titleAttributedString
        contentLabel.attributedText = contentAttributedString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    
}
