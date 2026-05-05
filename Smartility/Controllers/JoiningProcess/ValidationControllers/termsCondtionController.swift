//
//  termsCondtionController.swift
//  Smartility
//
//  Created by Mani on 9/18/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation
import UIKit

class termsCondtionController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
}

extension termsCondtionController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "termsCell", for: indexPath) as? termsCell
        cell?.textView.isEditable = false
        cell?.textView.isSelectable = false
        cell?.closeBtn.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        cell?.titileLabel.adjustsFontSizeToFitWidth = true
        return cell!
    }
    
    @objc func closeClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
    }
}


class termsCell: UITableViewCell{
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    override class func awakeFromNib() {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}
