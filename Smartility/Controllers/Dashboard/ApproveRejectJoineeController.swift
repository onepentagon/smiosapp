//
//  ApproveRejectJoineeController.swift
//  Smartility
//
//  Created by Mani on 1/22/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class ApproveRejectJoineeController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var menuView: UIView!
    
    var joiningModel = [joingRequestModel]()
    
    var dimView: UIView?
    var joiningRejectView = JoiningRejectView().loadNib() as? JoiningRejectView
    var constaint_height: NSLayoutConstraint?
    var centerConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                menuHeight.constant = 60
            case 1334:
                print("iPhone 6/6S/7/8")
                menuHeight.constant = 80
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            default:
                menuHeight.constant = 90
            }
        }else{
            menuHeight.constant = 90
        }
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backCLicked)))
        
        
        self.view.bringSubviewToFront(menuView)
        menuView.backgroundColor = .white
        menuView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 1
        menuView.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    
    @objc func backCLicked(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension ApproveRejectJoineeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joiningModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ApproveRejectCell", for: indexPath) as? ApproveRejectCell {
            cell.ApplyCell(data: joiningModel[safe: indexPath.row])
            
            cell.acceptBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self, action: #selector(approveBtnClicked(_:)), for: .touchUpInside)
            
            cell.rejectBtn.tag = indexPath.row
            cell.rejectBtn.addTarget(self, action: #selector(rejectBtnClicked(_:)), for: .touchUpInside)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    @objc func approveBtnClicked(_ sender: UIButton){
        let index = sender.tag
        let model = joiningModel[index]
        print(model)
        if let jsonData = try? JSONEncoder().encode(model), let jsonString = String(data: jsonData, encoding: .utf8), var
            perams = convertToDictionary(text: jsonString) {
            perams.updateValue(UserDefaults.user_id, forKey: "actioned_by")
            perams.updateValue(community.community_id, forKey: "comm_id")
            SpinnerClass.shared.createSpinnerView(controller: self)
            Networking.shared.ApproveReject(URL: EndPoint.acceptJoin, perams: perams) { (success, error) in
                SpinnerClass.shared.removeActivityIndicator()
                if let _ = success {
                    self.view.makeToast("Joing request Approved successfully")                    
                    self.joiningModel.remove(at: index)
                    if self.joiningModel.count == 0 {
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.tableview.reloadData()
                    NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                }
                if let error = error {
                    self.showConfirmAlert(title: "", message:error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
    }
    @objc func rejectBtnClicked(_ sender: UIButton){
        
        let index = sender.tag
        let model = joiningModel[index]
        print(model)
        if let jsonData = try? JSONEncoder().encode(model), let jsonString = String(data: jsonData, encoding: .utf8), var
            perams = convertToDictionary(text: jsonString) {
            perams.updateValue(UserDefaults.user_id, forKey: "actioned_by")
            SpinnerClass.shared.createSpinnerView(controller: self)
            Networking.shared.ApproveReject(URL: EndPoint.rejectJoin, perams: perams) { (success, error) in
                SpinnerClass.shared.removeActivityIndicator()
                if let _ = success {
                    self.dimView = UIView(frame: UIScreen.main.bounds)
                    self.dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    self.view.addSubview(self.dimView!)
                    self.view.addSubview(self.joiningRejectView!)
                    self.dimView?.bringSubviewToFront(self.joiningRejectView!)
                    self.joiningRejectView?.backgroundColor = .white
                    self.joiningRejectView?.layer.cornerRadius = 5
                    self.joiningRejectView?.layer.masksToBounds = true
                    
                    self.joiningRejectView?.translatesAutoresizingMaskIntoConstraints = false
                    self.joiningRejectView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                
                    self.centerConstraint = self.joiningRejectView?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
                    self.centerConstraint?.isActive = true
                            
                    self.joiningRejectView?.setup()
                    self.joiningRejectView?.okeyBtn.setTitle("OK", for: .normal)
                    self.joiningRejectView?.okeyBtn.setTitleColor(UIColor.white, for: .normal)
                    self.joiningRejectView?.okeyBtn.backgroundColor = brandColor()
                    self.joiningRejectView?.okeyBtn.isEnabled = false
                    
                    self.joiningRejectView?.widthAnchor.constraint(equalToConstant: self.view.frame.width-40).isActive = true
                    self.constaint_height?.isActive = false
                    self.constaint_height = self.joiningRejectView?.heightAnchor.constraint(equalToConstant: 268)
                    self.constaint_height?.isActive = true
                    
                    self.dimView?.alpha = 0.0
                    self.joiningRejectView?.alpha = 0.0
                    
                    UIView.animate(withDuration: 0.5) {
                        self.dimView?.alpha = 1.0
                        self.joiningRejectView?.alpha = 1.0
                    }
                            
                    self.joiningRejectView?.textview.delegate = self
                    
                    self.joiningRejectView?.textview.text = "Type Here"
                    self.joiningRejectView?.textview.textColor = UIColor(hex: "#BDBDBD")

                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.outerTouch))
                    self.dimView?.isUserInteractionEnabled = true
                    self.dimView?.addGestureRecognizer(tap)
                    
                    self.joiningRejectView?.okeyBtn.tag = sender.tag
                    self.joiningRejectView?.okeyBtn.addTarget(self, action: #selector(self.okeyBtnCicked(_:)), for: .touchUpInside)
                    self.joiningRejectView?.canceBtn.addTarget(self, action: #selector(self.outerTouch), for: .touchUpInside)
                    self.joiningRejectView?.canceBtn.setTitleColor(brandColor(), for: .normal)
                    self.joiningRejectView?.canceBtn.layer.cornerRadius = 8
                    self.joiningRejectView?.canceBtn.layer.masksToBounds = true
                    self.joiningRejectView?.canceBtn.layer.borderWidth = 1
                    self.joiningRejectView?.canceBtn.layer.borderColor = brandColor().cgColor
                    
                    self.joiningRejectView?.okeyBtn.layer.cornerRadius = 8
                    self.joiningRejectView?.okeyBtn.layer.masksToBounds = true
                    self.joiningRejectView?.okeyBtn.layer.borderWidth = 1
                    self.joiningRejectView?.okeyBtn.layer.borderColor = brandColor().cgColor
                }
            }
        }
    }
    
    
    @objc func okeyBtnCicked(_ sender: UIButton){
        
        let index = sender.tag
        let model = joiningModel[index]
        print(model)
            
        if let jsonData = try? JSONEncoder().encode(model), let jsonString = String(data: jsonData, encoding: .utf8), let perams = convertToDictionary(text: jsonString) {
            SpinnerClass.shared.createSpinnerView(controller: self)
            
            var parameters = perams
            
            parameters.updateValue(true, forKey: "show_rej")
            
            if let text = joiningRejectView?.textview.text {
                parameters.updateValue(text, forKey: "rej_reason")
            }
            SpinnerClass.shared.createSpinnerView(controller: self)
            Networking.shared.ApproveReject(URL: EndPoint.rejectJoin, perams: parameters) { (success, error) in
                SpinnerClass.shared.removeActivityIndicator()
                if let _ = success {
                    
                    self.joiningModel.remove(at: index)
                    if self.joiningModel.count == 0 {
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.tableview.reloadData()
                    
                    self.view.makeToast("Joing request rejected successfully")
                    NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                }
                if let error = error {
                    self.showConfirmAlert(title: "", message:error.localizedDescription, buttonTitle: "Ok", buttonStyle: .default, confirmAction: nil)
                }
            }
        }
        
    }
    
    @objc func outerTouch(){
        view.endEditing(true)
        UIView.transition(with: joiningRejectView!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.joiningRejectView?.alpha = 0.0
            self.dimView?.alpha = 0.0
        }) { (tr) in
            self.joiningRejectView?.removeFromSuperview()
            self.dimView?.removeFromSuperview()
        }
        self.constaint_height?.constant = 225
        view.layoutIfNeeded()
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
extension ApproveRejectJoineeController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let textFieldString = textView.fullTextWith(range: range, replacementString: text){
            if !textFieldString.trimmingCharacters(in: .whitespaces).isEmpty {
                self.joiningRejectView?.okeyBtn.isEnabled = true
                self.centerConstraint?.isActive = false
                self.centerConstraint = self.joiningRejectView?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50)
                self.joiningRejectView?.okeyBtn.setTitleColor(UIColor.white, for: .normal)
                self.centerConstraint?.isActive = true
                
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }else{
                self.constaint_height?.constant = 268
                self.joiningRejectView?.okeyBtn.setTitleColor(UIColor.lightGray, for: .normal)
                self.joiningRejectView?.okeyBtn.isEnabled = false
                self.centerConstraint?.isActive = false
                self.centerConstraint = self.joiningRejectView?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
                self.centerConstraint?.isActive = true
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        return true
    }
}

// MARK: - UITextViewDelegate
extension ApproveRejectJoineeController {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if !joiningRejectView!.textview.text!.isEmpty && joiningRejectView!.textview.text! == "Type Here" {
            joiningRejectView!.textview.text = ""
            joiningRejectView!.textview.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
    
        if joiningRejectView!.textview.text.isEmpty {
            joiningRejectView!.textview.text = "Type Here"
            joiningRejectView!.textview.textColor = UIColor.lightGray
        }
    }
}
