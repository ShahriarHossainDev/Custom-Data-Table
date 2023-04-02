//
//  DataViewController.swift
//  Custom Data Table
//
//  Created by Shishir_Mac on 1/4/23.
//

import UIKit
import CoreData

class DataViewController: UIViewController {
    
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    private let cellIdentifier: String = "dataCell"
    private let cellITextFieldDentifier: String = "textFieldCell"
    // Reference NS Managed Object Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRows = [IndexPath]()
    // Data table
    var items: [Player]?
    
    var isdelete: Bool = false
    var isEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player"
        
        playerTableView.dataSource = self
        playerTableView.delegate = self
        playerTableView.separatorStyle = .none
        
        self.playerTableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: cellITextFieldDentifier)
        self.playerTableView.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        
        fetchPlayer()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Function
    func fetchPlayer() {
        do {
            let request = Player.fetchRequest() as NSFetchRequest<Player>
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.playerTableView.reloadData()
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        let actionController = UIAlertController(title: "Add New Player", message : "Enter Player Info...!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            if actionController.textFields![0].text == "" {
                print("Enter Name")    // You refuse OK
                
            } else {
                let newPlayer = Player(context: self.context)
                newPlayer.name = actionController.textFields![0].text
                
                // Save Data
                do {
                    try self.context.save()
                } catch {
                    print(error.localizedDescription)
                }
                
                // Re-fetch data
                self.fetchPlayer()
            }
        } )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        actionController.addAction(okAction)
        actionController.addAction(cancelAction)
        
        actionController.addTextField { textField -> Void in
            textField.placeholder = "Enter Player Name..."
        }
        
        self.present(actionController, animated: true, completion: nil)
    }
}

extension DataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > 0 {
            if let cellTwo = tableView.dequeueReusableCell(withIdentifier: cellITextFieldDentifier) as? TextFieldTableViewCell {
                return cellTwo
            }
        }
        
        if let cellOne = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DataTableViewCell {
            cellOne.configurateTheCell(items![indexPath.row])
            cellOne.favoriteButton.addTarget(self, action: #selector(favoriteSelection(_:)), for: .touchUpInside)
            return cellOne
        }
        
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = self.items![indexPath.row]
        
        let actionController = UIAlertController(title: "Edit Player Name", message : nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            if actionController.textFields![0].text == "" {
                print("Enter Task")
            } else {
                
                task.name = actionController.textFields![0].text
                
                do {
                    try self.context.save()
                } catch {
                    print(error.localizedDescription)
                }
                self.fetchPlayer()
            }
            
        } )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        actionController.addAction(okAction)
        actionController.addAction(cancelAction)
        
        actionController.addTextField { textField -> Void in
            textField.text = task.name
        }
        
        self.present(actionController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let personTORemove = self.items![indexPath.row]
            
            self.context.delete(personTORemove)
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            self.fetchPlayer()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    @objc func favoriteSelection(_ sender:UIButton) {
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        if self.selectedRows.contains(selectedIndexPath) {
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: selectedIndexPath)!)
        } else {
            self.selectedRows.append(selectedIndexPath)
        }
        self.playerTableView.reloadData()
    }
}
