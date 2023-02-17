//
//  NotificationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 18/07/22.
//

import UIKit

class NotificationVC: UIViewController {

    //MARK: - Variables
    var headerData : [String] = ["TODAY","YESTERDAY"]
    //MARK:- IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var notificationLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    


}

//MARK: - SetUpUI
extension NotificationVC{
    func setUpUI(){
        CommonUI.setUpLbl(lbl: self.notificationLbl, text: L10n.Notifications.description, textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Large.sizeValue()))
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
    }
}

//Mark:- table view delegates and dataSource
extension NotificationVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath)as! NotificationTVC
        cell.setupCell(text: "")
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
        self.navigationController?.popViewController(animated: true)
    }
}
