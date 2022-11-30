//
//  SavedBooksTableViewController.swift
//  AbaoProjectPartB
//
//  This is a different way of showing data using ViewController with table view component
//  instead of using table view controller
//
//  Created by Alesson Abao on 17/11/22.
//

import UIKit
import CoreData

class SavedBooksTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var savedBooksTableView: UITableView!
    
    // data from database container
    var googleBooksData = [GoogleBooks]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googleBooksData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell", for: indexPath) as! SavedBooksTableViewCell

        let picData = googleBooksData[indexPath.row].pic
        cell.savedBooksImage?.image = UIImage(data: picData!)
        
        cell.savedBooksTitleLabel.text = googleBooksData[indexPath.row].title

        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // reference to AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        // fetch data from database
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GoogleBooks")
        googleBooksData = try! context.fetch(fetchRequest) as! [GoogleBooks]
    }
    
    // Reference: https://www.youtube.com/watch?v=I0Qeq7wBmNM&ab_channel=CodeWithCal
    // when user clicks row, connected to DetailViewController.swift
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue")
        {
            let indexPath = self.savedBooksTableView.indexPathForSelectedRow!
            let tableViewDetail = segue.destination as? DetailViewController
            
            let selectedBook = googleBooksData[indexPath.row]
            
            tableViewDetail!.selectedBook = selectedBook
            
            self.savedBooksTableView.deselectRow(at: indexPath, animated: true)
            
        }
    }

}
