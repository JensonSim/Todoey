//
//  ViewController.swift
//  Todoey
//
//  Created by J.Sim on 2018/05/02.
//  Copyright © 2018年 J.Sim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Egg", "Destory Dragon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    //Mark - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }//체크마크가없으면 체크하고 있으면 제거
        
        
        tableView.deselectRow(at: indexPath, animated: true)//바로 그레이 하이라이트가 사라지게
        
    }
    //Mark - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var alertText = UITextField()
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            //what will happen once the user clicks the add button
            print(alertText.text!)
            self.itemArray.append(alertText.text!)
            print(self.itemArray)
            self.tableView.reloadData()// tableView 는 UItableViewController 의 종속변수
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertText = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

