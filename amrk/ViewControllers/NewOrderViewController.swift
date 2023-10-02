/*********************		Yousef El-Madhoun		*********************/
//
//  NewOrderViewController.swift
//  amrk
//
//  Created by yousef on 31/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit

class NewOrderViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var lblQuantity: UILabel!
    
    @IBOutlet weak var tbMealExtra: UITableView!
    
    @IBOutlet weak var consMealExtra: NSLayoutConstraint!
    
    @IBOutlet weak var tbRemoveMealExtra: UITableView!
    
    @IBOutlet weak var consRemoveMealExtra: NSLayoutConstraint!
    
    var object: RestaurantMenuItem?
    
    var objectHala: HalaMenuItem?
    
    var additions: [Addition] = []
    
    var removes: [Addition] = []
    
    var additionsId: [Int] = []
    
    var removesId: [Int] = []
    
    var callback: ((_ order: NewOrderItem?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.layoutSubviews()
        self.scrollView.layoutIfNeeded()
        self.consMealExtra.constant = self.additions.count == 0 ? 50 : self.tbMealExtra.contentSize.height
        self.consRemoveMealExtra.constant = self.removes.count == 0 ? 50 : self.tbRemoveMealExtra.contentSize.height
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPlus(_ sender: Any) {
        let currentQuantity = Int(self.lblQuantity.text ?? "0")
        
        if let obj = self.object {
            if currentQuantity ?? 0 < obj.quantity ?? 0 {
                self.lblQuantity.text = "\((currentQuantity ?? 0) + 1)"
                self.clacTotalPriceRestaurant()
            }
        } else if let obj = self.objectHala {
            if currentQuantity ?? 0 < obj.quantity ?? 0 {
                self.lblQuantity.text = "\((currentQuantity ?? 0) + 1)"
                self.clacTotalPriceHala()
            }
        }
        
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        let currentQuantity = Int(self.lblQuantity.text ?? "0")
        
        if currentQuantity ?? 0 > 1 {
            if let _ = self.object {
                self.lblQuantity.text = "\((currentQuantity ?? 0) - 1)"
                self.clacTotalPriceRestaurant()
            } else if let _ = self.objectHala {
                self.lblQuantity.text = "\((currentQuantity ?? 0) - 1)"
                self.clacTotalPriceHala()
            }
        }
    }
    
    @IBAction func btnAddOrder(_ sender: Any) {
        
        let quantity = Int(self.lblQuantity.text ?? "0")
        
        var additionsPrice = 0.0
        
        for id in self.additionsId {
            for item in self.additions {
                if id == item.id {
                    additionsPrice += Double(item.price ?? 0) ?? 0
                }
            }
        }
        
        let object = NewOrderItem(order: self.object, orderHala: self.objectHala, removes: self.removesId, additions: self.additionsId, quantity: quantity, additionsPrice: additionsPrice)
        
        self.callback?(object)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NewOrderViewController {
    
    func setupView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let _ = self.object {
                self.clacTotalPriceRestaurant()
            } else if let _ = self.objectHala {
                self.clacTotalPriceHala()
            }
        }
        
        self.tbMealExtra.register(UINib(nibName: "MealExtraTableViewCell", bundle: nil), forCellReuseIdentifier: "MealExtraTableViewCell")
        self.tbRemoveMealExtra.register(UINib(nibName: "RemoveMealExtraTableViewCell", bundle: nil), forCellReuseIdentifier: "RemoveMealExtraTableViewCell")
    }
    
    func localized() {
        
    }
    
    func setupData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let obj = self.object {
                self.imgItem.imageURL(url: obj.image ?? "")
                self.lblType.text = obj.name
                self.lblPrice.text = "\(obj.price ?? 0) \("SAR".localize_)"

                self.additions = obj.additions ?? []
                self.removes = obj.removes ?? []
            } else if let obj = self.objectHala {
                self.imgItem.imageURL(url: obj.image ?? "")
                self.lblType.text = obj.name
                self.lblPrice.text = "\(obj.price ?? 0) \("SAR".localize_)"
                
                self.additions = obj.additions ?? []
                self.removes = obj.removes ?? []
            }
            
            self.tbMealExtra.reloadData()
            self.tbRemoveMealExtra.reloadData()
        }
    }
    
    func fetchData() {
        
    }

}

extension NewOrderViewController {
    
    func clacTotalPriceRestaurant() {
        
        let mealPrice = Double(self.object?.price ?? 0) ?? 0
        let quantity = Double(self.lblQuantity.text ?? "1") ?? 1
    
        var additionsPrice = 0.0
        
        for id in self.additionsId {
            for item in self.additions {
                if id == item.id {
                    additionsPrice += Double(item.price ?? 0)
                }
            }
        }
        
        self.lblTotalPrice.text = "\((mealPrice * quantity) + (additionsPrice * quantity)) \("SAR".localize_)"
    }
    
    func clacTotalPriceHala() {
        
        let halaPrice = Double(self.objectHala?.price ?? 0) ?? 0
        let quantity = Double(self.lblQuantity.text ?? "1") ?? 1
    
        var additionsPrice = 0.0
        
        for id in self.additionsId {
            for item in self.additions {
                if id == item.id {
                    additionsPrice += Double(item.price ?? 0)
                }
            }
        }
        
        self.lblTotalPrice.text = "\((halaPrice * quantity) + (additionsPrice * quantity)) \("SAR".localize_)"
    }
    
}

extension NewOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tbMealExtra {
            return self.additions.count
        } else {
            return self.removes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tbMealExtra {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealExtraTableViewCell", for: indexPath) as! MealExtraTableViewCell
            cell.object = self.additions[indexPath.row]
            cell.configureCell()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveMealExtraTableViewCell", for: indexPath) as! RemoveMealExtraTableViewCell
            cell.object = self.removes[indexPath.row]
            cell.configureCell()
            return cell
        }
    }
    
}
