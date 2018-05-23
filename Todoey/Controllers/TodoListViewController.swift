//
//  ViewController.swift
//  Todoey
//
//  Created by J.Sim on 2018/05/02.
//  Copyright © 2018年 J.Sim. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, UIPickerViewDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var itemNaviTitle: UINavigationItem!
    
    var itemArray = [Item]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet{
            itemNaviTitle.title = selectedCategory?.name!
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
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
        
        //데이터베이스에서 지워야하는거네 // 아니다 아이템어레이에서 지우면 되네 -> 둘다 지워야되네 ㅋㅋㅋㅋㅋ
        //db만 지우면, 
        //어레이만 지우면 일단 사라졌다가 재실행하면 다시나옴
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        saveData()
        tableView.reloadData()
        
      
        
        
        tableView.deselectRow(at: indexPath, animated: true)//바로 그레이 하이라이트가 사라지게
        
    }
    
    
    
    
    
    
    
    //Mark - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        var alertText = UITextField()
        
        
        
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            //what will happen once the user clicks the add button
            print(alertText.text!)
            
            let newItem = Item(context: self.context)
            newItem.title = alertText.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
    
    //Mark - Update exist Items
//    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
//        
//    }
    
    
    
    //Mark - Save Item to CoreData
    func saveData(){
        

        do{
            try context.save()
        } catch {
            print("error in saving \(error)")
        }
        
        tableView.reloadData()// tableView 는 UItableViewController 의 종속변수
        
    }
    
    //Mark: - Load Item from CoreData
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
        do{
            
        itemArray = try context.fetch(request)
            
        } catch {
            print("Error: \(error)")
        }
        
        tableView.reloadData()

    }

    
}

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: request.predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
        }
    }
    
}


