//
//  CategoryViewController.swift
//  Todoey
//
//  Created by J.Sim on 2018/05/21.
//  Copyright © 2018年 J.Sim. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
    var realm = try! Realm()
//    var categoryArray = [AnCategory]()
    var categoryArray: Results<AnCategory>?
    var selectedCategory:String = ""
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category Added yet"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "gotoItemView", sender: self)
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
    
    func loadData(){
        
        let categoryArray = realm.objects(AnCategory.self)
        tableView.reloadData()
    
    }
    
    
    

    
    


}
