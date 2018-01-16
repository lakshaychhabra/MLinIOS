//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lakshay Chhabra on 16/01/18.
//  Copyright © 2018 Lakshay Chhabra. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

 
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        

        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?){
             let destinationVC = segue.destination  as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        
        }
        
        
    }
    
    
    
    
    //MARK:- functions for data Manipulations
    
    func saveCategories(){
        
        print("Save Categories function")
        do{
        try context.save()
        }
        catch{
            print("Error Saving the Category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        print("load Categories")
        do{
           categoryArray = try context.fetch(request)
            
        }
        catch{
            print("Error Fetching the data \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    //MARK:- Button Pressed

    
    @IBAction func addButtonIsPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
            
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Add a new Category"
            
            
            
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
