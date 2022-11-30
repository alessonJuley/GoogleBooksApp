//
//  SavedBooksTableViewCell.swift
//  AbaoProjectPartB
//
//  This is connected to SavedBooksTableViewController.swift
//
//  Created by Alesson Abao on 17/11/22.
//

import UIKit

class SavedBooksTableViewCell: UITableViewCell {

    @IBOutlet weak var savedBooksImage: UIImageView!
    @IBOutlet weak var savedBooksTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
