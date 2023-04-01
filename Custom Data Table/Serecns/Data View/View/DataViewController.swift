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
    // Reference NS Managed Object Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data table
    var items: [Player]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player"
        
        playerTableView.dataSource = self
        playerTableView.delegate = self
        playerTableView.separatorStyle = .none
        
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
            print("Error")
        }
        
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        let actionController = UIAlertController(title: "Add New Player", message : "Enter Player Info...!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            if actionController.textFields![0].text == "" {
                print("Enter Name")    // You refuse OK
            } else {
                print("OK")     // Do whatever you need: update tableView
            }
            if actionController.textFields![1].text == "" {
                print("Enter Favorite")     // You refuse OK
            } else {
                let newPlayer = Player(context: self.context)
                newPlayer.name = actionController.textFields![0].text
                newPlayer.favorite = false
                
                // Save Data
                do {
                    try self.context.save()
                } catch {
                    
                }
                
                // Re-fetch data
                self.fetchPlayer()  // Do whatever you need:  update tableView
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
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DataTableViewCell {
            cell.configurateTheCell(items![indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let personTORemove = self.items![indexPath.row]
            
            self.context.delete(personTORemove)
            
            do {
                try self.context.save()
            } catch {
                
            }
            
            self.fetchPlayer()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
