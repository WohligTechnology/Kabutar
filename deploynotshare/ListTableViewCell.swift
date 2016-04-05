//
//  ListTableViewCell.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 26/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import MGSwipeTableCell
class ListTableViewCell: MGSwipeTableCell {
    
    @IBOutlet weak var ListViewTitle: UILabel!
    @IBOutlet weak var ListLock: UIImageView!
    @IBOutlet weak var DetailViewTitle: UILabel!
    @IBOutlet weak var DetailDescription: UILabel!
    @IBOutlet weak var DetailTimeStamp: UILabel!
    @IBOutlet weak var DetailLock: UIImageView!
    @IBOutlet weak var ntfTitle: UILabel!
    @IBOutlet weak var ntfDescription: UILabel!
    @IBOutlet weak var ntfImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
