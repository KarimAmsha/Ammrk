/*********************		Yousef El-Madhoun		*********************/
//
//  SelectDateReserveViewController.swift
//  amrk
//
//  Created by yousef on 18/09/2021.
//  Copyright © 2021 yousef. All rights reserved.
//

import UIKit
import FSCalendar

class SelectDateReserveViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var objectRestaurant: RestaurantDetails?
    
    var objectHala: Hala?
    var objectWedding: RoomItemData?
    var objectTraining: RoomItemData?

    var calendarDate = Calendar.current
    var dateSelected: String?
    var components: DateComponents?
    var year: Int?
    var month: Int?
    
    var reserveTimes: [String] = []
    
    var reserveSelectedTime: Int?
    var selecteddd: Date?
    var callback: ((_ date: String?, _ time: String?) -> Void)?
    
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        
        guard let _ = dateSelected else {
            self.showSnackbarMessage(message: "Pleace Enter The Reservation Date".localize_, isError: true)
            return
        }
        
        guard let timeIndex = reserveSelectedTime else {
            self.showSnackbarMessage(message: "Please choose the time".localize_, isError: true)
            return
        }
        
//        guard date.toDate(customFormat: "yyyy-MM-dd").compare("".toDate(customFormat: "yyyy-MM-dd")).rawValue == 1 else {
//            self.showSnackbarMessage(message: "Please choose a valid date".localize_, isError: true)
//            return
//        }
        
        let str = (self.reserveTimes[timeIndex])
//        let index = str.index(str.startIndex, offsetBy: 4)

        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        print(str)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let datee = dateFormatter.date(from: str)!
        print(datee)
        
        

        
        let time1 = 60*Calendar.current.component(.hour, from: datee) + Calendar.current.component(.minute, from: datee)
        let time2 =  60*Calendar.current.component(.hour, from: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()) + Calendar.current.component(.minute, from: Date())
        
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone(identifier: "UTC")
        
        dateFormatter2.dateFormat = "YYYY-MM-dd HH:mm:ss"
        print("date selected \(self.dateSelected ?? "")")
        let strdate = dateFormatter2.string(from: selecteddd!)
        
        let dd = dateFormatter2.date(from: strdate )!
//
        print("date selected dd \(dd)")
        let now = Date()
        print("date now \(now)")

        let strdateNow = dateFormatter2.string(from: now)
        print("str date now \(strdateNow)")

        let ddNow = dateFormatter2.date(from: strdateNow)!
        print("date date now \(ddNow)")

        
        let m = ddNow.fullDistance(from: dd, resultIn: .minute)!
        print(ddNow.fullDistance(from: dd, resultIn: .minute)!)
        
        if m == 0 {
            
            if time2 > time1 {
                self.showSnackbarMessage(message: "Please choose a valid date".localize_, isError: true)
                return
            } else {
                print("Valid")
            }
        } else if m < 0 {
            self.showSnackbarMessage(message: "Please choose a valid date".localize_, isError: true)
            return
        }else {
            print("Valid")
        }
        
        self.callback?(self.dateSelected ?? "", self.reserveTimes[timeIndex])
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension SelectDateReserveViewController {
    
    func setupView() {
        calendar.setNeedsLayout()
        calendar.layoutIfNeeded()
        calendar.delegate = self
        calendar.dataSource = self
//        components = calendarDate.dateComponents([.year, .month], from: calendar.currentPage)
//        year =  components?.year
//        month = components?.month
        
        self.collectionView.register(UINib(nibName: "ReserveTimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReserveTimeCollectionViewCell")
    }
    
    func localized() {
        
    }
    
    func setupData() {
        if let obj = self.objectRestaurant {
            let openFrom = obj.userInfo?.openFrom?.toDate(customFormat: "HH:mm")
            let openTo = obj.userInfo?.openTo?.toDate(customFormat: "HH:mm")
            
            self.getTimes(openFrom: openFrom ?? Date(), openTo: openTo ?? Date(), value: openFrom ?? Date())
        } else if let obj = self.objectHala {
            let openFrom = obj.userInfo?.openFrom?.toDate(customFormat: "HH:mm")
            let openTo = obj.userInfo?.openTo?.toDate(customFormat: "HH:mm")
            
            self.getTimes(openFrom: openFrom ?? Date(), openTo: openTo ?? Date(), value: openFrom ?? Date())
        } else  if let obj = self.objectWedding{
            let openFrom = obj.userInfo?.openFrom?.toDate(customFormat: "HH:mm")
            let openTo = obj.userInfo?.openTo?.toDate(customFormat: "HH:mm")
            
            self.getTimes(openFrom: openFrom ?? Date(), openTo: openTo ?? Date(), value: openFrom ?? Date())
        } else if let obj = self.objectTraining {
            let openFrom = obj.userInfo?.openFrom?.toDate(customFormat: "HH:mm")
            let openTo = obj.userInfo?.openTo?.toDate(customFormat: "HH:mm")
            
            self.getTimes(openFrom: openFrom ?? Date(), openTo: openTo ?? Date(), value: openFrom ?? Date())
        }
    }
    
    func fetchData() {
        
    }

}

extension SelectDateReserveViewController {
    
    func getTimes(openFrom: Date, openTo: Date, value: Date) {
        
        var newDate = value

        if value.compare(openTo).rawValue == -1 {
            newDate.addTimeInterval(15 * 60)
            self.reserveTimes.append(newDate.toString(customFormat: "HH:mm"))
            getTimes(openFrom: openFrom, openTo: openTo, value: newDate)
        }
    }
    
}

extension SelectDateReserveViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reserveTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReserveTimeCollectionViewCell", for: indexPath) as! ReserveTimeCollectionViewCell
        cell.indexPath = indexPath
        cell.object = self.reserveTimes[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.reserveSelectedTime = indexPath.row
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 80
        let height = 45
        return CGSize(width: width, height: height)
    }
    
}

extension SelectDateReserveViewController: FSCalendarDelegate, FSCalendarDataSource {
    
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        components = calendarDate.dateComponents([.year, .month], from: calendar.currentPage)
//        year =  components?.year
//        month = components?.month
//    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        print(tomorrow)
        selecteddd = tomorrow
        dateSelected = tomorrow.toString(customFormat: "YYYY-MM-dd")
        
   }
    
}

extension Date {

    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
