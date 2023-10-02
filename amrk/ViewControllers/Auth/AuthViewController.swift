/*********************		Yousef El-Madhoun		*********************/
//
//  AuthViewController.swift
//  amrk
//
//  Created by yousef on 12/08/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import FSPagerView

class AuthViewController: UIViewController {

    @IBOutlet weak var pageControll: FSPageControl! {
        didSet {
            self.pageControll.numberOfPages = self.sliderItems.count
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
    
    var sliderItems: [AdsItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSkip(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
}

extension AuthViewController {
    
    func setupView() {

    }
    
    func localized() {
        
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
        
        let request = BaseRequest()
        request.url = GlobalConstants.ADS
        request.method = .get
        
        RequestBuilder.requestWithSuccessfullRespnose(for: AdsModel.self, request: request, showErrorMessage: false) { (result) in
            
            if result.data?.items?.count ?? 0 > 0 {
                self.sliderItems = result.data?.items ?? []
                self.pagerView.reloadData()
                self.pageControll.numberOfPages = result.data?.items?.count ?? 0
                self.pageControll.currentPage = 0
            }
            
        }
        
    }
    
}

extension AuthViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.sliderItems.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.imageURL(url: sliderItems[index].image ?? "")
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.clipsToBounds = true
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControll.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControll.currentPage = pagerView.currentIndex
    }
    
}
