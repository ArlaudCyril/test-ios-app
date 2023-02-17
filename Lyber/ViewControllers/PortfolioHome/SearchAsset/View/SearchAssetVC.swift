//
//  SearchAssetVC.swift
//  Lyber
//
//  Created by sonam's Mac on 25/08/22.
//

import UIKit

class SearchAssetVC: UIViewController {
    //MARK: - Variables
    var searchAssetVM = SearchAssetVM()
    var allAssets : [GetAssetsAPIElement] = []
    var assetNameCallback :((String)->())?
    //MARK:- IB OUTLETS
    @IBOutlet var headerVw: HeaderView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callAssetsApi()
    }

}
//MARK: - SetUpUI
extension SearchAssetVC{
    func setUpUI(){
        self.headerVw.headerLbl.isHidden = true
        self.headerVw.backBtn.setImage(Assets.back.image(), for: .normal)
        CommonUI.setUpViewBorder(vw: searchView, radius: 12, borderWidth: 1, borderColor: UIColor.borderColor.cgColor)
        searchTF.delegate = self
       
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.headerVw.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        searchTF.addTarget(self, action: #selector(searchTextChange), for: .editingChanged)
    }
}

//MARK: - objective functions
extension SearchAssetVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchTextChange(){
        self.searchAssetVM.getAssetsApi(searchText: searchTF.text ?? "",completion: {[weak self]response in
            CommonFunction.hideLoader(self?.view ?? UIView())
            if let response = response{
                self?.allAssets = []
                self?.allAssets = response
                self?.tblView.reloadData()
            }
        })
    }
    
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension SearchAssetVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  allAssets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAssetTVC", for: indexPath) as! SearchAssetTVC
        cell.setUpCell(data: allAssets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        assetNameCallback?(self.allAssets[indexPath.row].assetID ?? "")
    }
}

//MARK:- Text Field Delegates
extension SearchAssetVC: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.searchAssetVM.getAssetsApi(searchText: searchTF.text ?? "",completion: {[weak self]response in
            CommonFunction.hideLoader(self?.view ?? UIView())
            if let response = response{
                self?.allAssets = []
                self?.allAssets = response
                self?.tblView.reloadData()
            }
        })
        return true
    }
}

//MARK: - Other functions
extension SearchAssetVC{
    func callAssetsApi(){
        CommonFunction.showLoader(self.view)
        self.searchAssetVM.getAssetsApi(searchText: "", completion: {[weak self]response in
            CommonFunction.hideLoader(self?.view ?? UIView())
            if let response = response{
                self?.allAssets = response
                self?.tblView.reloadData()
            }
        })
    }
}
