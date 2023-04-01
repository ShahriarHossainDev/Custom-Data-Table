//
//  DataTableViewCell.swift
//  Custom Data Table
//
//  Created by Shishir_Mac on 1/4/23.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var dataContentView: UIView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataContentView.layer.borderWidth = 1
        dataContentView.layer.borderColor = UIColor(ciColor: .black).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Cell Configuration
    
    func configurateTheCell(_ player: Player) {
        playerNameLabel.text = player.name
        if player.favorite == false {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
}
