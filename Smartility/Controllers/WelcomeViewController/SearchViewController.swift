//
//  SearchViewController.swift
//  Smartility
//
//  Created by Mani on 7/6/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    var searchActive : Bool = false
        
    var placeHolder: String?
    var data = [String]()
    var filtered:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.placeholder = placeHolder
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        search.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        tableview.reloadData()
        
        if #available(iOS 13.0, *) {
            search.searchTextField.autocorrectionType = .yes
            search.searchTextField.keyboardAppearance = .dark            
        } else {
            // Fallback on earlier versions
        }
    }
}


extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive){
            
            if filtered.count == 0 {
                tableView.setEmptyMessage("No Data")
                return 0
            }else{
                tableView.setEmptyMessage("")
                return filtered.count
            }
        } else {
            if data.count == 0 {
                tableView.setEmptyMessage("No Data")
                return 0
            }else{
                tableView.setEmptyMessage("")
                return data.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "communityNameCell", for: indexPath) as? communityNameCell
        
        if(cell == nil)
        {
            cell = UITableViewCell(style:.default, reuseIdentifier: "communityNameCell") as? communityNameCell
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell?.textLabel?.sizeToFit()
        
        if(searchActive){
            cell?.textLabel?.text = filtered[indexPath.row]
        } else {
            cell?.textLabel?.text = data[indexPath.row]
        }
        
        cell?.textLabel?.numberOfLines = 0
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height:CGFloat = calculateHeight(inString: self.data[indexPath.row])
        return height + 20.0        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data:String? = nil
        if(searchActive){
            data = self.filtered[indexPath.row]
        }else{
            data = self.data[indexPath.row]
        }
        NotificationCenter.default.post(name: NSNotification.Name("pass_name"), object: self, userInfo: ["name":data ?? ""])
        dismiss(animated: true, completion: nil)
    }
    
    
    func calculateHeight(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes = [NSAttributedString.Key.font:
            UIFont(name: "Helvetica-Bold", size: 15.0)!,
                          NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key: Any]
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText  = searchText
        
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
}
