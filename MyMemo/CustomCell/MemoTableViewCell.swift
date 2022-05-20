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
        
    }
    
    func configure(memo: Memo) {
        titleLabel.text = memo.title
        dateLabel.text = memo.writeAt.toString()
        contentLabel.text = memo.content
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    
}
