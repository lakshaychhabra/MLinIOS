//
//  ViewController.swift
//  Todoey
//
//  Created by Lakshay Chhabra on 13/01/18.
//  Copyright © 2018 Lakshay Chhabra. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Eggs", "Milk", "Fruits"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Mark:- TableView dataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
            cell.textLabel?.text = itemArray[indexPath.row]
        
                return cell
        
    }

    //Mark:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
    
    

}

