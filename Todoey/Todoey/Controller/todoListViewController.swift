//
//  ViewController.swift
//  Todoey
//
//  Created by Lakshay Chhabra on 13/01/18.
//  Copyright © 2018 Lakshay Chhabra. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    
    var itemArray = [Item]()

    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")  //Was used for plist
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print("Started")
        
       
        
        loadItems()
        
//        if let items = defaults.array(forKey: "TodolistArray" ) as? [Item] {
//            itemArray = items
//        }earlier we used it for defaults but now we using decoders
        
        
    }
    
    //Mark:- TableView dataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
            cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        } used ternanary instead of this
        
                return cell
        
    }

    //Mark:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //for deleting
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        saveData()
       
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "ADD NEW TO LIST", message: "", preferredStyle:.alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user will click add button
            
         
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
        
            self.saveData()
            
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(){
//        let encoder = PropertyListEncoder()
        do{
//            let data = try encoder.encode(itemArray) //plist methhod
//            try data.write(to: dataFilePath!)
            
            try context.save()
            
            
        }catch{
//            print("error encoding")
            
            print("error saving context")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> =  Item.fetchRequest()){
//
//        let data = try? Data(contentsOf: dataFilePath!)
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data!)
//            }catch{
//                print("Error decoding \(error)")
//            }
//
//that was for plist
        
        
        
    // now for core data
        
       
//
  
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error Fetching data" )
        }
         tableView.reloadData()
    }
    
    
    
    
    
    

}

extension TodoListViewController : UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request  : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        
            request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItems(with: request)
        
        
       
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //when any change in text of search bar
        if searchBar.text?.count == 0
        {
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
            
           
        }
        
        
        
    }
    
    
    
}

















