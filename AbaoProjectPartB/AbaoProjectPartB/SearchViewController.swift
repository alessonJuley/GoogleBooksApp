//
//  SearchViewController.swift
//  AbaoProjectPartB
//
//  "Brain" of this app
//  search from API and save to CoreData
//
//  Created by Alesson Abao on 14/11/22 for mobile app development course
//

import UIKit
import CoreData

// MARK: Alert function
func showMessage(message: String, buttonCaption: String, controller: UIViewController)
{
    // create UIAlertController
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    // create action [Is alert default, cancel, etc.]
    let action = UIAlertAction(title: buttonCaption, style: .default)
    // add action to alert
    alert.addAction(action)
    // show it to controller
    controller.present(alert, animated: true)
}

class SearchViewController: UIViewController {
    // MARK: Variables saved in CoreData
    var itemTitle : String!
    var itemLanguage : String!
    var itemPublishedDate : String!
    
    // MARK: Outlets
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var searchErrorLabel: UILabel!
    
    @IBOutlet weak var searchedTitleLabel: UILabel!
    @IBOutlet weak var searchedPublishDateLabel: UILabel!
    @IBOutlet weak var searchedLanguageLabel: UILabel!
    @IBOutlet weak var searchedPicView: UIImageView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetSearch()
    }
    
    // MARK: Validation functions
    // Reference: https://www.youtube.com/watch?v=5Rn6JJAuyK0&t=183s&ab_channel=CodeWithCal
    func resetSearch()
    {
        authorTextField.text = ""
        searchErrorLabel.text = "Search must not be empty"
        searchErrorLabel.isHidden = false
        searchButton.isEnabled = false
        saveButton.isEnabled = false
        
        searchedTitleLabel.text = ""
        searchedPublishDateLabel.text = ""
        searchedLanguageLabel.text = ""
        searchedPicView.image = nil
    }
    
    func checkForValidForm()
    {
        if(searchErrorLabel.isHidden)
        {
            searchButton.isEnabled = true
            saveButton.isEnabled = true
        }
        else
        {
            searchButton.isEnabled = false
            saveButton.isEnabled = false
        }
    }
    
    
    @IBAction func searchChanged(_ sender: Any) {
        if let author = authorTextField.text
        {
            if let errorMessage = invalidAuthor(author)
            {
                searchErrorLabel.text = errorMessage
                searchErrorLabel.isHidden = false
            }
            else
            {
                searchErrorLabel.isHidden = true
            }
        }
        checkForValidForm()
        
    }
    
    func invalidAuthor(_ value : String) -> String?
    {        
        if value.count < 1
        {
            return "Please enter author's full name"
        }
        
        return nil // no error at this point
    }
    
    
    // MARK: Search from API

    @IBAction func searchAuthor(_ sender: UIButton) {
        fetchData()
    }
    
    private func fetchData()
    {
        // take search input
        let keyword = authorTextField.text!
        // accept user input with spaces
        // code snippet from Stackoverflow https://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
        let keywordToURL = keyword.replacingOccurrences(of: " ", with: "+")
        
        // MARK: API with Key
        // find website address from where we want to download the data
        // address for searching author only
        var address = "https://www.googleapis.com/books/v1/volumes?q=search+inauthor:\(keywordToURL)&key=AIzaSyAFUqJtRGqqJ03LXBP9CgccID1Hj7khKjQ"
        
        // make object of URL to make a connection to server
        let googleUrl = URL(string: address)
        
        // make URL request object to send over the network
        let urlRequest = URLRequest(url: googleUrl!)
        
        // create task object, what you want to do when connection is made in the server
        let task = URLSession.shared.dataTask(with: urlRequest)
        {
            (data,response,error)
            in
            if(error == nil)
            {
                // whole data
                let jsonData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                // ======================USED FOR TESTING======================
                // let items = jsonData["items"] as? [[String:Any]] ?? []
                // let randomNumber = (Int)(arc4random_uniform((UInt32)(items.count)))

                // let itemVolinfo = items[randomNumber]["volumeInfo"] as? [String:Any] ?? [:]
                
                // print("This is item volume info: \(itemVolinfo)")    // all volume info
                // print(type(of: itemVolinfo))                         // Dictionary<String, Any>
                // ======================USED FOR TESTING======================
                
                // check if author has available books in Google Books
                var items : [[String:Any]]!
                // if author has books availble, go here
                if((jsonData["items"]) != nil)
                {
                    items = jsonData["items"] as? [[String:Any]] ?? []
                    let randomNumber = (Int)(arc4random_uniform((UInt32)(items.count)))
                    
                    // ======================USED FOR TESTING======================
                    // print("This is random number: \(randomNumber)")
                    // print("This is items: \(items)")
                    // ======================USED FOR TESTING======================
                    
                    // get book info
                    let itemVolinfo = items[randomNumber]["volumeInfo"] as? [String:Any] ?? [:]
                    
                    // MARK: 4 Attributes from API
                    // ================Variables you want to save from core data================
                    // The variables you want to save from a volume are book title,
                    // language, published date, book cover/thumbnail (if available)
                    
                    self.itemTitle = itemVolinfo["title"] as? String ?? "Not Available"
                    self.itemLanguage = itemVolinfo["language"] as? String ?? "Not Available"
                    self.itemPublishedDate = itemVolinfo["publishedDate"] as? String ?? "Not Available"
                    
                    // because imageLinks are sometimes nil, use if statement to save image if it's available
                    var imageLinks : [String: Any]!
                    if((itemVolinfo["imageLinks"]) != nil)
                    {
                        // if imageLinks is not nil, convert to [String:Any]
                        imageLinks = itemVolinfo["imageLinks"] as? [String: Any]
                        
                        // ======================USED FOR TESTING======================
                        // print("This is image links: \(imageLinks)")
                        // print("This is type of image links: \(type(of: imageLinks))") // Dictionary<String, Any>
                        // ======================USED FOR TESTING======================
                        
                        // use if statement again if thumbnail is available to save
                        var thumbnail : String
                        if(imageLinks["thumbnail"] != nil)
                        {
                            thumbnail = imageLinks["thumbnail"] as! String
                            
                            // ======================USED FOR TESTING======================
                            // print("This is thumbnail: \(thumbnail)")
                            // print("This is type of thumbnail: \(type(of: thumbnail))") // String
                            // ======================USED FOR TESTING======================
                            
                            let thumbnailURL = URL(string: thumbnail)
                            let picData = try! Data(contentsOf: thumbnailURL!)
                            let pic = UIImage(data: picData)
                            
                            DispatchQueue.main.async { [self] in
                                // show data in labels
                                searchedTitleLabel.text = itemTitle
                                searchedPublishDateLabel.text = "Published Date: \(itemPublishedDate!)"
                                searchedLanguageLabel.text = "Language: \(itemLanguage!)"
                                // available thumbnail will be displayed
                                self.searchedPicView.image = pic
                            }
                        }
                    }
                    // if imageLink is nil, go here
                    else
                    {
                        DispatchQueue.main.async { [self] in
                            // show data in labels
                            searchedTitleLabel.text = itemTitle
                            searchedPublishDateLabel.text = "Published Date: \(itemPublishedDate!)"
                            searchedLanguageLabel.text = "Language: \(itemLanguage!)"
                            // Reference: https://stackoverflow.com/questions/27039140/programmatically-set-image-to-uiimageview-with-xcode-6-1-swift/39746722#39746722
                            // show no book cover pic, can be found in Assets.xcassets
                            self.searchedPicView.image = UIImage(named: "noBookCover")
                        }
                    }
                }
                // if author does not have available books in Google Books, go here
                else
                {
                    DispatchQueue.main.async { [self] in
                        
                        searchedTitleLabel.text = "Book Not Available"
                        searchedPublishDateLabel.text = "Published Date: Not Available"
                        searchedLanguageLabel.text = "Language: Not Available"
                        self.searchedPicView.image = nil
                        // disable save button when there is no books available to save
                        saveButton.isEnabled = false
                        authorTextField.text = ""
                    }
                }
            }
            else    // end of if(error == nil)
            {
                showMessage(message: error.debugDescription, buttonCaption: "Close", controller: self)
            }
        }           // end of let task
        task.resume()
    }
    
    // MARK: Save to Core Data
    @IBAction func saveBook(_ sender: UIButton) {
        // reference to database
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        // reference to Google Books table
        let bookData = NSEntityDescription.insertNewObject(forEntityName: "GoogleBooks", into: context) as! GoogleBooks
        
        // save data to GoogleBooks table
        bookData.title = itemTitle
        bookData.publishedDate = itemPublishedDate
        bookData.language = itemLanguage
        bookData.pic = searchedPicView.image?.pngData()
        
        do
        {
            try context.save()
            showMessage(message: "Book Saved 🥳", buttonCaption: "Close", controller: self)
            resetSearch()
        }
        catch
        {
            showMessage(message: "Data Insertion Error", buttonCaption: "Try Again", controller: self)
            resetSearch()
        }
        
    }
}
