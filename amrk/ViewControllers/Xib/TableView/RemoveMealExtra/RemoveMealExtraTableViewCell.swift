//
//  RemoveMealExtraTableViewCell.swift
//  amrk
//
//  Created by yousef on 31/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import BEMCheckBox

class RemoveMealExtraTableViewCell: UITableViewCell {

    @IBOutlet weak var chAction: BEMCheckBox!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var object: Addition?
    
    func configureCell() {
        if let obj = object {
            self.lblTitle.text = obj.name
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        
        chAction.on = !chAction.on
        
        if let parent = self.parentViewController as? NewOrderViewController {
            if chAction.on {
                parent.additionsId.append(object?.id ?? -1)
            } else {
                for (index, id) in parent.additionsId.enumerated() {
                    if id == self.object?.id {
                        parent.additionsId.remove(at: index)
                        break
                    }
                }
            }
        }
        
    }
    
    @IBAction func chAction(_ sender: Any) {
        if let parent = self.parentViewController as? NewOrderViewController {
            if chAction.on {
                parent.additionsId.append(object?.id ?? -1)
            } else {
                for (index, id) in parent.additionsId.enumerated() {
                    if id == self.object?.id {
                        parent.additionsId.remove(at: index)
                        break
                    }
                }
            }
        }
    }
    
}
