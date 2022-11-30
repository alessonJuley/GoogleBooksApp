//
//  ShowTableViewCell.swift
//  AbaoProjectPartB
//
//  THIS IS JUST FOR TESTING ON HOW TO VIEW DATA USING TABLEVIEWCONTROLLER!!!!!
//
//  This is the cell part for ShowTableViewController.swift
//
//  You use this if you choose to show the data using TableViewController instead of
//  View Controller with table view component in it
//
//  Created by Alesson Abao on 14/11/22 for mobile app development course
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
