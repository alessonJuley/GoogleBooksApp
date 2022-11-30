//
//  DetailViewController.swift
//  AbaoProjectPartB
//
//  Shows book detail
//  connected to ShowTableViewController.swift
//
//  Created by Alesson Abao on 15/11/22 for mobile app development course
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailPicView: UIImageView!
    @IBOutlet weak var detailPublishedDateLabel: UILabel!
    @IBOutlet weak var detailLanguageLabel: UILabel!
    
    var selectedBook : GoogleBooks!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTitleLabel.text = selectedBook.title
        
        let picData = selectedBook.pic
        detailPicView?.image = UIImage(data: picData!)
        
        detailPublishedDateLabel.text = "Published Date: \(selectedBook.publishedDate!)"
        detailLanguageLabel.text = "Language: \(selectedBook.language!)"
    }

}
