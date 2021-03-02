//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ahmed on 12/01/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController : SwipeTableViewController {
    let color = UIColor.randomFlat().hexValue()
    //let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var category : Results<Category>?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
      loadItem()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navBar = navigationController?.navigationBar {
            navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "there's no category added yet"
        cell.backgroundColor = UIColor(hexString: category?[indexPath.row].color ?? "1D9BF6")
      

        // Configure the cell...

        return cell
    }
    // MARK: - tableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoTOItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexpath = tableView.indexPathForSelectedRow {
            let destinsionVc = segue.destination as! TodoeyListViewController
            destinsionVc.categorySelected = category?[indexpath.row]
        }
    }

    //MARK: - Manipulate Data
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "Create Category You Want", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Your Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = text.text!
            newCategory.color = UIColor.randomFlat().hexValue()
           
            self.save(category: newCategory)
        print("Success")
            
        }
        
          
        alert.addTextField { (textfield) in
            text = textfield
        }
        alert.addAction(action)
        present(alert,animated: true)
        }
    
    func save(category:Category)  {
       
                  do{
                    try realm.write{
                        
                        realm.add(category.self)
                    }
                  }catch{
                      print("Error\(error)")
                  }
              
                  DispatchQueue.main.async {
                      self.tableView.reloadData()
          
                  }

    }
    
    func loadItem(){
        
         category = realm.objects(Category.self)
       
    }
    
    
    override func getIndexPath(indexPath: IndexPath) {
        if let currentIndexPath = self.category?[indexPath.row]{
                do{
                                   try  self.realm.write(){
                                       self.realm.delete(currentIndexPath)
                                   }
                               }catch{
                                   print("delete error \(error)")
                               }
            }
           
        
    }
}
    
    // MARK: - SwipeTableViewCell

 
    

