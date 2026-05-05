//
//  CommunityDropDown.swift
//  Smartility
//
//  Created by Mani on 4/7/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class CommunityDropDown: UIView {
    @IBOutlet weak var communityTable: UITableView!
    var communitList: [String] = []
    var selectedCommunityIndex = Int()
    var didUpdate: (String,Int) -> () = { _,_  in }
    
    func setupTable(){
        communityTable.register(UINib(nibName: "CommunityDropDownCell", bundle: .main), forCellReuseIdentifier: "CommunityDropDownCell")
        communityTable.delegate = self
        communityTable.dataSource = self
        communityTable.reloadData()
    }
}
extension CommunityDropDown: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communitList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityDropDownCell", for: indexPath) as? CommunityDropDownCell
        cell?.communityName.text = communitList[indexPath.row]
        if selectedCommunityIndex == indexPath.row {
            cell?.selectedCheckMark.image = UIImage(named: "Checked")
        }else{
            cell?.selectedCheckMark.image = nil
        }        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didUpdate(communitList[indexPath.row],indexPath.row)
    }
}
