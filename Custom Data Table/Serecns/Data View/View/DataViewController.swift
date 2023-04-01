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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player"
        
        // Do any additional setup after loading the view.
    }
    
}
