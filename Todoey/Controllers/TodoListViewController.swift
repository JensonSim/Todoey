//
//  ViewController.swift
//  Todoey
//
//  Created by J.Sim on 2018/05/02.
//  Copyright © 2018年 J.Sim. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController, UIPickerViewDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var itemNaviTitle: UINavigationItem!
    var realm = try! Realm()
    var todoItems: Results<Item>?
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : AnCategory? {
        didSet{
            itemNaviTitle.title = selectedCategory?.name
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
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoitemCell")
        
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
//            cell.detailTextLabel?.text = item.dateCreated!
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        
        return cell // 셀을 하나 잡아서 순서대로, 아이템어레이의 순서대로 추가
        
        
    }
    //Mark - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
//                    item.done = !item.done
                }
            } catch {
            print("\(error)")
                
        }
            tableView.reloadData()

//        //데이터베이스에서 지워야하는거네 // 아니다 아이템어레이에서 지우면 되네 -> 둘다 지워야되네 ㅋㅋㅋㅋㅋ
//        //db만 지우면,
//        //어레이만 지우면 일단 사라졌다가 재실행하면 다시나옴
////        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
////        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
//
//        saveData()
//        tableView.reloadData()
//
//
//
//
        tableView.deselectRow(at: indexPath, animated: true)//바로 그레이 하이라이트가 사라지게
        
    }
    }
    
    
    
    
    
    
    //Mark - Add new Items
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        var alertText = UITextField()
        
        
        
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            //what will happen once the user clicks the add button
            print(alertText.text!)
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = alertText.text!
                        newItem.dateCreated = Date.init()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("\(error)")
                }
                
            }

            
            self.loadItems()

        }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            
            alertText = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    Mark - Update exist Items
//    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
//
//    }
    
    
    
    //Mark - Save Item to CoreData
//    func saveData(item: Item){
//
//
//        do{
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("error in saving \(error)")
//        }
//
////        tableView.reloadData()// tableView 는 UItableViewController 의 종속변수
//
//    }
    
    //Mark: - Load Item from CoreData
    func loadItems() {

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name)
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
////
////        if let additionalPredicate = predicate {
////            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
////        }else {
////            predicate = categoryPredicate
////        }
//
//        do{

//            todoItems = realm.objects(Item.self).filter(categoryPredicate)

//        } catch {
//            print("Error: \(error)")
        

        tableView.reloadData()
    }
    

}


extension TodoListViewController: UISearchBarDelegate{
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
////
//       predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: request.predicate)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
//
        } else {
          todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        }
        tableView.reloadData()
    }




}
