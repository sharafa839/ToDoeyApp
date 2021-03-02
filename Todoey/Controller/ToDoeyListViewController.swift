//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework
class TodoeyListViewController: SwipeTableViewController {
    @IBOutlet weak var uiSearchBar: UISearchBar!
    var toDoItems: Results<Item>?
    var realm = try! Realm()
   // let defaults = UserDefaults.standard
   // let pathFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    var categorySelected:Category? {
        didSet{
        loadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
       
        title = categorySelected?.name
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let hexColor = categorySelected?.color{
                   guard let navBar = navigationController?.navigationBar else {
                       fatalError("Error When get navbar")
                   }
            uiSearchBar.barTintColor = UIColor(hexString: hexColor)
                if let navColor = UIColor(hexString: hexColor){
                    navBar.tintColor = ContrastColorOf(navColor, returnFlat: true)
                    navBar.backgroundColor =  UIColor(hexString: hexColor)
                    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navColor, returnFlat: true)]
            
            }
           
            
            
          
                         
               }
        
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row]{
            
                cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            
        }
        else{
            cell.textLabel?.text = "there's no items yet"
        }
        
        if let colour = UIColor(hexString: categorySelected!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItems!.count)){
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
       /* if item?.done == true {
            cell.accessoryType = .checkmark
         }else{
            cell.accessoryType = .none
           // /Users/ahmed/Desktop/Development/Todoey-iOS13/Todoey/Controller/ToDoeyListViewController.swift:57:32: Cannot convert value of type 'Item' to expected argument type 'NSManagedObject'
        }*/
       
       // saveItem()
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]{
            do{
            try realm.write{
                item.done = !item.done
               // realm.delete(item)
            }
            }catch{
                print("error Upditing database\(error)")
            }
        }
        tableView.reloadData()

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
      let alert = UIAlertController(title: "Add", message: "Add a spacific Task", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.categorySelected{
                do{
                    try self.realm.write{
                          let newItem = Item()
                           newItem.title = textField.text!
                           newItem.done = false
                        newItem.dateCreated = Date()
                        newItem.toDoColor = UIColor.randomFlat().hexValue()
                            currentCategory.items.append(newItem)
                }
                    self.tableView.reloadData()
                }catch{
                    print(error)
                }
            }
        }
    
       alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder  = "add new item"
            textField = alertTextField
        }
        
            self.present(alert,animated: true)
    }
    
   
  func loadData(){
    
      
    toDoItems = categorySelected?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    override func getIndexPath(indexPath: IndexPath) {
        if let currentPath = toDoItems?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(currentPath)
                }
            }catch{
                print(" Error from get index path at to do list view controller \(error)    ")
                
            }
            
        }
    }
    
}

extension TodoeyListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           
        toDoItems = toDoItems?.filter("title CONTAINS [cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
       
      
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            searchBar.resignFirstResponder()

        }
        
    }
    
}
