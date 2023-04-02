//
//  TextFieldTableViewCell.swift
//  Custom Data Table
//
//  Created by Shishir_Mac on 2/4/23.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var addPlayerView: UIView!
    @IBOutlet weak var playerTextField: UITextField!
    @IBOutlet weak var plusButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerTextField.delegate = self
        
        addPlayerView.layer.borderWidth = 1
        addPlayerView.layer.borderColor = UIColor(ciColor: .black).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - UITextViewDelegate
extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\(textField.text ?? "")")
        return true
    }
}
