/*********************		Yousef El-Madhoun		*********************/
//
//  OnBoardingViewController.swift
//  amrk
//
//  Created by yousef on 23/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import FSPagerView

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var pageControll: FSPageControl! {
        didSet {
            self.pageControll.numberOfPages = 3
            pageControll.setFillColor(UIColor.hexColor(hex: "#D2D2D2"), for: .normal)
            pageControll.setFillColor("#219CD8".color_, for: .selected)
        }
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    let titles = [
        "Discover places\nnear you".localize_,
        "Choose A Tasty\nDish".localize_,
        "Pick Up Your\nDelivery".localize_,
    ]
    
    let details = [
        "We make it simple to find the food\nyou crave. Enter your address and let\nus do the rest.".localize_,
        "When you order Eat Street, we'll hook\nyou up with exclusive coupons,\nspecials and rewards.".localize_,
        "We make food ordering fast, simple\nand free - no matter if you order\nonline or cash.".localize_,
    ]
    
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
    
    @IBAction func btnSkip(_ sender: Any) {
        
        UserProfile.shared.isOpenApp = true
        
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        vc.isFromOnBoarding = true
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension OnBoardingViewController {
    
    func setupView() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        self.lblTitle.text = self.titles[0]
        self.lblDetails.text = self.details[0]
    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
    }

}

extension OnBoardingViewController {
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .left:
                if self.pageControll.currentPage < 2 {
                    self.pageControll.currentPage += 1
                }
                break
            case .right:
                if self.pageControll.currentPage > 0 {
                    self.pageControll.currentPage -= 1
                }
                break
            default:
                break
            }
            
            self.pagerView.selectItem(at: Int(self.pageControll.currentPage), animated: true)
            self.pagerView.deselectItem(at: Int(self.pageControll.currentPage), animated: true)
            
        }
    }
    
}

extension OnBoardingViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = "imgOnBoarding-\(index + 1)".image_
        cell.imageView?.clipsToBounds = true
        cell.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.pagerView.deselectItem(at: Int(self.pageControll.currentPage), animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControll.currentPage = targetIndex
        self.lblTitle.text = self.titles[targetIndex]
        self.lblDetails.text = self.details[targetIndex]
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControll.currentPage = pagerView.currentIndex
        self.lblTitle.text = self.titles[pagerView.currentIndex]
        self.lblDetails.text = self.details[pagerView.currentIndex]
    }
    
}
