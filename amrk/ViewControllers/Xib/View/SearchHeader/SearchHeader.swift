//
//  SearchHeader.swift
//  amrk
//
//  Created by yousef on 02/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class SearchHeader: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var lblTitle: UILabel!
    
    var title: String {
        set {
            lblTitle.text = newValue.localize_
        } get {
            return lblTitle.text?.localize_ ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureXib()
    }
    
    private func configureXib() {
        Bundle.main.loadNibNamed("SearchHeader", owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
    }
    
}
