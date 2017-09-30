//
//  TextCell.swift
//  WeiXinTouTiao
//
//  Created by KaFeiDou on 2017/9/27.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
