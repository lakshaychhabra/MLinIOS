//
//  ViewController.swift
//  Todoey
//
//  Created by Lakshay Chhabra on 13/01/18.
//  Copyright © 2018 Lakshay Chhabra. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print("Started")
        
       
  
        
    }
    
    //Mark:- TableView dataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
     
   
                return cell
        
    }

    //Mark:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//
//        saveData()
       
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "ADD NEW TO LIST", message: "", preferredStyle:.alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user will click add button
          
            print("inside closure")
         
            if let currentCategory = self.selectedCategory{
                print("before Do")
                do{
                        print("Inside Do")
                    try self.realm.write {
                        print("writing")
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                        print("Written")
                    }
                }catch{
                    print("Error Saving the Items \(error)")
                }
            }
            print("outside closure gng")
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
    
    func loadItems(){
        print("under load items")
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      
         tableView.reloadData()
    }

    
    
    
    
    

}

//extension TodoListViewController : UISearchBarDelegate{
//
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request  : NSFetchRequest<Item> = Item.fetchRequest()
//
//       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//
//
//            request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
//
//
//        loadItems(with: request, predicate: predicate)
//
//
//
//
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //when any change in text of search bar
//        if searchBar.text?.count == 0
//        {
//            loadItems()
//
//            DispatchQueue.main.async {
//
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//
//
//
//    }
    
    
    


















