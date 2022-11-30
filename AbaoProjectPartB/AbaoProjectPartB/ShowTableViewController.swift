//
//  ShowTableViewController.swift
//  AbaoProjectPartB
//
//  THIS IS JUST FOR TESTING ON HOW TO VIEW DATA USING TABLEVIEWCONTROLLER!!!!!
//
//  Shows all saved books, this is using tableViewController
//  this is connected to ShowTableViewCell.swift
//
//  I put it here so you can see the difference in code if you choose to use
//  table view controller instead of using view controller and adding
//  table view component inside the view controller
//
//  Created by Alesson Abao on 14/11/22 for mobile app development course
//

import UIKit
import CoreData

class ShowTableViewController: UITableViewController {

    // data from database container
    var googleBooksData = [GoogleBooks]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // reference to AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        // fetch data from database
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GoogleBooks")
        googleBooksData = try! context.fetch(fetchRequest) as! [GoogleBooks]
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return googleBooksData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowTableViewCell

        let picData = googleBooksData[indexPath.row].pic
        cell.showImage?.image = UIImage(data: picData!)
        
        cell.showTitle.text = googleBooksData[indexPath.row].title

        return cell
    }
    
    // Reference: https://www.youtube.com/watch?v=I0Qeq7wBmNM&ab_channel=CodeWithCal
    // when user clicks row, connected to DetailViewController.swift
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue")
        {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let tableViewDetail = segue.destination as? DetailViewController
            
            let selectedBook = googleBooksData[indexPath.row]
            
            tableViewDetail!.selectedBook = selectedBook
            
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
