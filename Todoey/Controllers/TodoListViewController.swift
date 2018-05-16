//
//  ViewController.swift
//  Todoey
//
//  Created by J.Sim on 2018/05/02.
//  Copyright © 2018年 J.Sim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Mike"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Mike"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Find Mike"
        itemArray.append(newItem4)
        
        let newItem7 = Item()
        newItem7.title = "Find Mike"
        itemArray.append(newItem7)
        
        let newItem5 = Item()
        newItem5.title = "Find Mike"
        itemArray.append(newItem5)
        
        let newItem6 = Item()
        newItem6.title = "Find Mike"
        itemArray.append(newItem6)
        
        
        let newItem8 = Item()
        newItem8.title = "Find Mike"
        itemArray.append(newItem8)
        
        let newItem9 = Item()
        newItem9.title = "Find Mike"
        itemArray.append(newItem9)
        
        
        
        
        //if let items = defaults.array(forKey: "ItemArrayList") as? [String]{
      //      itemArray = items
      //  }
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoitemCell")
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
        let item = itemArray[indexPath.row].title
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        } // 번호에 맞는 어레이의 변수를 확인하고 완료가 체크되어있다면 체크마크된 셀을 내보냄, 테이블뷰에서 하는것과 다른점은 테이블 뷰를 뿌리고 체크마크를 붙이는가, 아니면 셀을 내보낼때 체크마크를 붙여서 내보내는가.
        
        
        return cell // 셀을 하나 잡아서 순서대로, 아이템어레이의 순서대로 추가
        
        
    }
    //Mark - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //if itemArray[indexPath.row].done == true {
          //  itemArray[indexPath.row].done = false
        //} else {
         //   itemArray[indexPath.row].done = true
        //}
        
       tableView.reloadData()
        
        //if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
          //  tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //} else {
          //  tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //}//체크마크가없으면 체크하고 있으면 제거
        
        
        tableView.deselectRow(at: indexPath, animated: true)//바로 그레이 하이라이트가 사라지게
        
    }
    //Mark - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        var alertText = UITextField()
        
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            //what will happen once the user clicks the add button
            print(alertText.text!)
            
            let newItem = Item()
            newItem.title = alertText.text!
            
            self.itemArray.append(newItem)
            
           // self.defaults.set(self.itemArray, forKey: "ItemArrayList")
            
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

