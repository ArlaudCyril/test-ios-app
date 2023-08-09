//
//  NotificationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 18/07/22.
//

import UIKit

class NotificationVC: SwipeGesture {

    //MARK: - Variables
    var headerData : [String] = []
	var notificationArraySorted = [[NotificationData]] ()
	var totalRows = 0
	var numberOfNotificationsPerRequest = 50
	var bottomReached = false
	
	let minScrollXOffset = -56
	let maxScrollXOffset = 0
	var isScrollingHorizontally = false
	var isScrollingVertically = false
    //MARK:- IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var notificationLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
		loadNextNotifications()
    }
	
	//MARK: - SetUpUI
    override func setUpUI(){
		CommonUI.setUpLbl(lbl: self.notificationLbl, text: CommonFunctions.localisation(key: "ACTIVITY_LOGS"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
		
    }
	
	
}

//MARK: - table view delegates and dataSource
extension NotificationVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
		return headerData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notificationArraySorted[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == headerData.count-1 && indexPath.row == self.notificationArraySorted[indexPath.section].count-1 && !self.bottomReached{
			loadNextNotifications()
		}
		
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath)as! NotificationTVC
		cell.setupCell(notification: notificationArraySorted[indexPath.section][indexPath.row])
		cell.controller = self
		
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationHeaderTVC")as! NotificationHeaderTVC
        cell.setUpCell(data: headerData[section])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
	
}

//MARK: - objective functions
extension NotificationVC{
    @objc func cancelBtnAct(){
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - other functions
extension NotificationVC{
	func sortingNotificationsBySection(notifications: [NotificationData]){
		var sortedNotficationDictionary = [String: [NotificationData]] ()
		let calendar = Calendar.current
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		
		let titleDateFormatter = DateFormatter()
		titleDateFormatter.dateFormat = "dd/MM/yyyy"
		
		for notification in notifications {
			let date1 = Calendar.current.startOfDay(for: formatter.date(from: notification.date) ?? Date())
			let date2 = Calendar.current.startOfDay(for: Date())
			let components = calendar.dateComponents([.day], from: date1, to: date2)
			if(components.day ?? 0 == 0){
				//today
				if(!headerData.contains("TODAY")){
					headerData.append("TODAY")
					sortedNotficationDictionary["TODAY"] = [notification]
				}else{
					sortedNotficationDictionary["TODAY"]?.append(notification)
				}
				
			}else if(components.day ?? 0 == 1){
				//yesterday
				if(!headerData.contains("YESTERDAY")){
					headerData.append("YESTERDAY")
					sortedNotficationDictionary["YESTERDAY"] = [notification]
				}else{
					sortedNotficationDictionary["YESTERDAY"]?.append(notification)
				}
				
			}else if(components.day ?? 0 >= 2){
				//previous yesterday, we print the date
				let date = formatter.date(from: notification.date) ?? Date()
				let dateTitle = titleDateFormatter.string(from: date)
				
				if(!headerData.contains(dateTitle)){
					headerData.append(dateTitle)
					sortedNotficationDictionary[dateTitle] = [notification]
				}else{
					sortedNotficationDictionary[dateTitle]?.append(notification)
				}
				
			}
		}

		self.notificationArraySorted += sortedNotficationDictionary.map { (key, value) in
			return (value)
		}
	}
	
	func loadNextNotifications(){
		NotificationVM().notificationsGetNotificationsAPI(limit: numberOfNotificationsPerRequest, offset: totalRows, completion: {[]response in
			if(response != nil){
				if(response?.data.count ?? 0 < self.numberOfNotificationsPerRequest){
					//stop requesting
					self.bottomReached = true
				}
				self.sortingNotificationsBySection(notifications: response?.data ?? [])
				self.totalRows += self.numberOfNotificationsPerRequest
				self.tblView.reloadData()
			}
		})
	}
	
	func scrollTableView(by offset: CGFloat = 0, stateEnded : Bool = false) {
		let maxScrollYOffset = max(0, tblView.contentSize.height - tblView.frame.height)

		if(stateEnded == true){
			if(self.tblView.contentOffset.y > CGFloat(maxScrollYOffset)){
				self.tblView.contentOffset.y = CGFloat(maxScrollYOffset)
			}
		}else{
			
			if(tblView.contentOffset.y < tblView.frame.height/2)
			{
				tblView.contentOffset.y = max(0,tblView.contentOffset.y + offset)
			}else{
				if(self.tblView.contentOffset.y + offset < CGFloat(maxScrollYOffset) || offset < 0)
				{
					self.tblView.contentOffset.y = min(CGFloat(maxScrollYOffset), self.tblView.contentOffset.y + offset)
				}
			}
		}
		
		
	}
	
	
}
