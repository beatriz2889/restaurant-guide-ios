//
//  ViewController.swift
//  PersonalRestaurantGuide
//
//  Created by Tech on 2021-03-05.
//  Copyright © 2021 georgebrown. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var entryArray = [Entry]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        let entry = entryArray[indexPath.row]
        cell.textLabel?.text = entry.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = self.entryArray[indexPath.row]
        
        var nameTextField = UITextField()
        var addressTextField = UITextField()
        var phoneTextField = UITextField()
        var descriptionTextField = UITextField()
        var ratingTextField = UITextField()
        var tagsTextField = UITextField()
        let alert = UIAlertController(title: "View Details", message: "", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "Update Entry", style: .default) { (action) in
            self.entryArray[indexPath.row].setValue(nameTextField.text, forKey: "name")
            self.entryArray[indexPath.row].setValue(addressTextField.text, forKey: "address")
            self.entryArray[indexPath.row].setValue(phoneTextField.text, forKey: "phone")
            self.entryArray[indexPath.row].setValue(descriptionTextField.text, forKey: "desc")
            self.entryArray[indexPath.row].setValue(ratingTextField.text, forKey: "rating")
            self.entryArray[indexPath.row].setValue(tagsTextField.text, forKey: "tags")
            self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel )
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertNameTextField) in
            alertNameTextField.placeholder = entry.name
            nameTextField = alertNameTextField
        }
        alert.addTextField { (alertAddressTextField) in
            alertAddressTextField.placeholder = entry.address
            addressTextField = alertAddressTextField
        }
        alert.addTextField { (alertPhoneTextField) in
            alertPhoneTextField.placeholder = entry.phone
            phoneTextField = alertPhoneTextField
        }
        alert.addTextField { (alertDescTextField) in
            alertDescTextField.placeholder = entry.desc
            descriptionTextField = alertDescTextField
        }
        alert.addTextField { (alertRatingTextField) in
            alertRatingTextField.placeholder = entry.rating
            ratingTextField = alertRatingTextField
        }
        alert.addTextField { (alertTagsTextField) in
            alertTagsTextField.placeholder = entry.tags
            tagsTextField = alertTagsTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let entryToRemove = self.entryArray[indexPath.row]
            self.context.delete(entryToRemove)
            
            do{
           try self.context.save()
            }catch{
                
            }
            self.loadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var nameTextField = UITextField()
        var addressTextField = UITextField()
        var phoneTextField = UITextField()
        var descriptionTextField = UITextField()
        var ratingTextField = UITextField()
        var tagsTextField = UITextField()
        let alert = UIAlertController(title: "Create New Entry", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Entry", style: .default) { (action) in
            let newEntry = Entry(context: self.context)
            newEntry.name = nameTextField.text
            newEntry.address = addressTextField.text
            newEntry.phone = phoneTextField.text
            newEntry.desc = descriptionTextField.text
            newEntry.rating = ratingTextField.text
            newEntry.tags = tagsTextField.text
            self.entryArray.append(newEntry)
            self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel )
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertNameTextField) in
            alertNameTextField.placeholder = "Name"
            nameTextField = alertNameTextField
            
            
        }
        alert.addTextField { (alertAddressTextField) in
            alertAddressTextField.placeholder = "Address"
            addressTextField = alertAddressTextField
        }
        
        alert.addTextField { (alertPhoneTextField) in
            alertPhoneTextField.placeholder = "Phone Number"
            phoneTextField = alertPhoneTextField
        }
        alert.addTextField { (alertDescriptionTextField) in
            alertDescriptionTextField.placeholder = "Description"
            descriptionTextField = alertDescriptionTextField
        }
        alert.addTextField { (alertRatingTextField) in
            alertRatingTextField.placeholder = "Rating /5"
            ratingTextField = alertRatingTextField
        }
        alert.addTextField { (alertTagsTextField) in
            alertTagsTextField.placeholder = "Tags"
            tagsTextField = alertTagsTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(){
        do{
           try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        let request : NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do{
            entryArray = try context.fetch(request)
            
        }catch{
            print("Error loading data \(error)")
            
        }
        tableView.reloadData()
    }

}

