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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        
        
        
       
        
        loadItems()
        
        
        //if let items = defaults.object(forKey: "ItemArrayList") as? [Item]{
       //     itemArray = items
        //}
        // Do any additional setup after loading the view, typically from a nib.
    }

    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoitemCell")
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Value to change = Condition to Check A==B ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //
        //if item.done == true {
         //   cell.accessoryType = .checkmark
        //} else {
          //  cell.accessoryType = .none
        //} // 번호에 맞는 어레이의 변수를 확인하고 완료가 체크되어있다면 체크마크된 셀을 내보냄, 테이블뷰에서 하는것과 다른점은 테이블 뷰를 뿌리고 체크마크를 붙이는가, 아니면 셀을 내보낼때 체크마크를 붙여서 내보내는가.
        
        
        return cell // 셀을 하나 잡아서 순서대로, 아이템어레이의 순서대로 추가
        
        
    }
    //Mark - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(item)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //if itemArray[indexPath.row].done == true {
          //  itemArray[indexPath.row].done = false
        //} else {
         //   itemArray[indexPath.row].done = true
        //}
        
        saveData()

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
            self.saveData()
           
        }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            alertText = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    func saveData(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error incoding item array")
        }
        tableView.reloadData()// tableView 는 UItableViewController 의 종속변수
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding items!")
            }
    }
    
    
}

}
