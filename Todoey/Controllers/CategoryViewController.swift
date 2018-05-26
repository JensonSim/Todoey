//
//  CategoryViewController.swift
//  Todoey
//
//  Created by J.Sim on 2018/05/21.
//  Copyright © 2018年 J.Sim. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework



class CategoryViewController: SwipeTableViewController {
    
    var realm = try! Realm()
//    var categoryArray = [AnCategory]()d
    var categoryArray: Results<AnCategory>?
    var selectedCategory:String = ""
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        loadData()
        
        tableView.separatorStyle = .none

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    //MARK - SwipeTable
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = SwipeTableViewCell(style: .default, reuseIdentifier: "Cell")
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArray?[indexPath.row]{
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)            

        }
        return cell
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "gotoItemView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categoryArray?[selectedIndexPath.row]
        }
    }
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "title:Create Category", message: "msg:Create Category", preferredStyle: .alert)
        var alertTextResult = UITextField()
        
        let action = UIAlertAction(title: "title:action", style: .default) { (action) in
            let newCategory = AnCategory() // Category가 context랑 이어진다고 하는듯?
            newCategory.name = alertTextResult.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            newCategory.color = UIColor(randomFlatColorOf : .light).hexValue()
//            self.categoryArray.append(newCategory)
            self.save(category: newCategory)

        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "PH:add category title"
            alertTextResult = alertTextField
        }
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }
    
    func save(category: AnCategory){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("saving error: \(error)")
        }
        tableView.reloadData()
        
    }
    
//    func delete(){
//
//
//    }
    
    func loadData(){
        
        categoryArray = realm.objects(AnCategory.self)
        tableView.reloadData()
    
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super .updateModel(at: indexPath)
        
        if let categoryDeletion = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryDeletion)
                    //                    item.done = !item.done
                    
                }
                
            } catch {
                print("\(error)")
                
            }
            
        }
    }

}


//MARK: - Swipe Cell Delegate Methods

