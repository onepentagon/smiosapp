//
//  InvoiceViewController.swift
//  Smartility
//
//  Created by Mani on 2/11/21.
//  Copyright © 2021 com.loyaleapp.pro. All rights reserved.
//

import UIKit

class Invoice_Payment_ViewController: UIViewController, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var chooseUnitContainerView: UIView!
    @IBOutlet weak var chooseUnitContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chooseContainerDropDownImage: UIImageView!
    @IBOutlet weak var chooseContainerTextLabel: UILabel!
    @IBOutlet weak var chooseContainerImageContainer: UIView!
    @IBOutlet weak var chooseContainerTable: UITableView!
    @IBOutlet weak var chooseContainerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var invoiceView: UIView!
    @IBOutlet weak var PaymentHistoryView: UIView!
    @IBOutlet weak var paymentHistoryContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentHistoryContainer: UIView!
    @IBOutlet weak var fromFeildContainer: UIView!
    @IBOutlet weak var toFeildContainer: UIView!
    @IBOutlet weak var fromFeildLabel: UILabel!
    @IBOutlet weak var toFeildLabel: UILabel!
    @IBOutlet weak var NoDueBackgroundView: UIView!
    @IBOutlet weak var noDueGreen: UIImageView!
    @IBOutlet weak var noDueRounded: UIImageView!
    @IBOutlet weak var noDueColored: UIImageView!
    @IBOutlet weak var noDuesLable: UILabel!
    @IBOutlet weak var chooseUnittopConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var backBgView: UIView!
    
                
    var chooseDropdown: UILabel?
    var fromLabel: UILabel?
    var toLabel: UILabel?
    var chooseDropDown = false
    var dropDownArray: [dropDownSelection]?
    var datefrom: String?
    var dateParams = [String:String]()
    var invoiceAndHistory: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
                      
        navigationTitle.textColor = brandColor()
        
        backBgView.setClickListener {
            self.navigationController?.popViewController(animated: true)
        }        
       
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
        
        menuView.layer.shadowColor = UIColor(red: 0.049, green: 0.019, blue: 0.167, alpha: 0.2).cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 1
        menuView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true

        chooseContainerTextLabel.textColor = UIColor(hex: "333333")
        chooseUnitContainerViewHeight.constant = 0
        for i in paymentHistoryContainer.subviews {
            i.alpha = 0.0
        }
        paymentHistoryContainerHeight.constant = 0
                        
                        
        chooseContainerTableHeight.constant = 0
        chooseContainerTable.separatorStyle = .none
        chooseContainerTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: chooseContainerTable.frame.width, height: 0))
        chooseContainerTable.layer.cornerRadius = 8
        chooseContainerTable.layer.masksToBounds = true
                                                                       
        chooseContainerDropDownImage.image = UIImage(named: "dropDownIC")
        chooseContainerDropDownImage.transform = chooseContainerDropDownImage.transform.rotated(by: -.pi / 2)                
        
        var dateComponent = DateComponents()
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        
        var curMonth = Int()
        if let curMonthDateString = futureDate?.toString(dateFormat: "MM"), let curMonthInt = Int(curMonthDateString) {
            curMonth = curMonthInt
        }
        
        if (curMonth >= 4) {
            let date = (futureDate?.toString(dateFormat: "yyyy") ?? "")+"-04-01"
            fromFeildLabel.text = date
            dateParams.updateValue(date, forKey: "from_dt")
        }else{
            dateComponent.year = -1
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date())
            let date = (futureDate?.toString(dateFormat: "yyyy") ?? "")+"-04-01"
            fromFeildLabel.text = date
            dateParams.updateValue(date, forKey: "from_dt")
        }
        dateParams.updateValue(Date().toString(dateFormat: "yyyy-MM-dd"), forKey: "to_dt")
        toFeildLabel?.text = Date().toString(dateFormat: "yyyy-MM-dd")
        
        fromFeildContainer.setClickListener {
            let selector = WWCalendarTimeSelector.instantiate()
            self.datefrom = "from"
            selector.optionStyles.showTime(false)
            selector.optionStyles.showDateMonth(true)
            selector.optionStyles.showYear(true)
            selector.delegate = self
            selector.optionTopPanelTitle = "Choose Date"
            self.present(selector, animated: true, completion: nil)
        }
        
        toFeildContainer.setClickListener {
            let selector = WWCalendarTimeSelector.instantiate()
            selector.optionStyles.showTime(false)
            self.datefrom = "to"
            selector.optionStyles.showDateMonth(true)
            selector.optionStyles.showYear(true)
            selector.delegate = self
            selector.optionTopPanelTitle = "Choose Date"
            self.present(selector, animated: true, completion: nil)
        }
        invoiceAndHistory = "invoice"
        chooseUnitContainerView.setClickListener {
            if !self.chooseDropDown {
                self.chooseContainerTable.delegate = self
                self.chooseContainerTable.dataSource = self
                UIView.animate(withDuration: 0.3, animations: {
                    self.chooseContainerTable.reloadData()
                    self.chooseContainerDropDownImage.transform = .identity
                    self.chooseContainerTableHeight.constant = CGFloat(((self.dropDownArray?.count ?? 0)*60))
                    self.view.layoutIfNeeded()
                }, completion: {
                    (value: Bool) in
                })
            }else{
                self.chooseContainerTable.delegate = nil
                self.chooseContainerTable.dataSource = nil
                UIView.animate(withDuration: 0.3, animations: {
                    self.chooseContainerDropDownImage.transform = self.chooseContainerDropDownImage.transform.rotated(by: -.pi / 2)
                    self.chooseContainerTableHeight.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: {(value: Bool) in
                    self.chooseContainerTable.reloadData()
                })
            }
            self.chooseDropDown.toggle()
        }
        
        
                
//        if #available(iOS 13.0, *) {
//            segmentControl.selectedSegmentTintColor = brandColor()
//        }
//        segmentControl.layer.borderWidth = 1.0
//        segmentControl.layer.borderColor = brandColor().cgColor

        
//        let normalAttribute1: [NSAttributedString.Key: Any] = [.font: SFFont(font: .Semibold, size: 16), .foregroundColor: UIColor.black]
//        segmentControl.setTitleTextAttributes(normalAttribute1, for: .normal)
//
//        let normalAttribute: [NSAttributedString.Key: Any] = [.font: SFFont(font: .Semibold, size: 16), .foregroundColor: UIColor.white]
//        segmentControl.setTitleTextAttributes(normalAttribute, for: .selected)
        
        segmentControl.ensureiOS12Style()
                
        self.title = "Invoice & Payments"
        PaymentHistoryView.alpha = 0
        chooseDropdown = chooseUnitContainerView.addTopLabel(labelText: "Unit", contreoller: self)
        fromLabel = fromFeildContainer.addTopLabel(labelText: "From", contreoller: self)
        toLabel = toFeildContainer.addTopLabel(labelText: "To", contreoller: self)
        
        chooseDropdown?.alpha = 0
        
        self.view.bringSubviewToFront(chooseContainerTable)
        getTopWindow()?.bringSubviewToFront(chooseContainerTable)
        _ = [toLabel,fromLabel].map {  $0?.alpha = 0 }
        
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: infoColor() ?? UIColor.clear]
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = infoColor()
        segmentControl.addTarget(self, action: #selector(segmentValueChange), for: .valueChanged)        
                
        segmentControl.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ShowNoDues"), object: nil, queue: .main) { (noDues) in
            if let nodues = noDues.userInfo as? [String:Any] {
                if let nodueText = nodues["NoDues"] as? String {
                    if nodueText == "Invoice" {
                        self.segmentControl.selectedSegmentIndex = 0
                        self.invoiceView.alpha = 1.0
                        self.hideTheNoDues()
                    }else if nodueText == "Payment" {
                        self.PaymentHistoryView.alpha = 1.0
                        self.hideTheNoDues()
                    }else {
                        if nodueText == "InvoiceNoDue" {
                            self.segmentControl.selectedSegmentIndex = 0
                            self.invoiceView.alpha = 0.0
                            self.PaymentHistoryView.alpha = 0.0
                            self.noDueColored.image = UIImage(named: "_noDueRounderBakround")
                            self.noDuesLable.text = "Yay! No Dues"
                            self.setupNoDues()
                        }else{
                            self.segmentControl.selectedSegmentIndex = 1
                            self.invoiceView.alpha = 0.0
                            self.PaymentHistoryView.alpha = 0.0
                            self.noDueColored.image = UIImage(named: "noHistory")
                            self.noDuesLable.text = "No Transaction History Found"
                            self.setupNoDues()
                        }
                    }
                }
                self.segmentControl.isUserInteractionEnabled = true
            }
        }
        
        dropDownArray = [dropDownSelection]()
        Networking.shared.getUnitsByUserId(id: "\(UserDefaults.user_id)/\(community.community_id)") { (model, error) in
            if let model = model {
                let linked =  model.filter { (model) -> Bool in
                    model.rel_status == "Linked"
                }
                if linked.count != 0 {
                    
                    let dropDownBU =  model.filter { (model) -> Bool in
                        model.rel_status == "Linked"
                    }.compactMap({
                        $0.block_and_unit
                    })
                                        
                    let dropDownID =  model.filter { (model) -> Bool in
                        model.rel_status == "Linked"
                    }.compactMap({
                        $0.unit_id
                    })
                                                       
                    for i in 0..<dropDownID.count {
                        self.dropDownArray?.append(dropDownSelection(selection: false, unitName: dropDownBU[i], unitID: dropDownID[i]))
                    }
                    
                    if dropDownID.count == 1 {
                        self.chooseUnittopConstraint.constant = 5
                        self.chooseUnitContainerViewHeight.constant = 0
                    }else{
                        self.chooseUnittopConstraint.constant = 25
                        self.chooseDropdown?.alpha = 1.0
                        self.chooseUnitContainerViewHeight.constant = 48
                    }
                    
                    
                    UnitDetails.shared.unitID = "\(self.dropDownArray?.first?.unitID ?? 0)"
                    UnitDetails.shared.unitName = self.dropDownArray?.first?.unitName ?? ""
                    self.chooseContainerTextLabel.text = self.dropDownArray?.first?.unitName ?? ""
                    
//                    self.dateParams.updateValue(UnitDetails.shared.unitName, forKey: "UnitName")
//                    self.dateParams.updateValue(UnitDetails.shared.unitID , forKey: "unit_id")
                    NotificationCenter.default.post(name: NSNotification.Name("LoadingInvoices"), object: nil)
                    
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func hideTheNoDues(){
        self.noDueGreen.alpha = 0.0
        self.noDueRounded.alpha = 0.0
        self.noDueColored.alpha = 0.0
        self.noDuesLable.alpha = 0.0
    }
    override func viewWillAppear(_ animated: Bool) {
        self.noDueGreen.alpha = 0.0
        self.noDueRounded.alpha = 0.0
        self.noDueColored.alpha = 0.0
        self.noDuesLable.alpha = 0.0
        noDuesLable.textColor = successColor()
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if datefrom == "to" {
            toFeildLabel.text = date.stringFromFormat("yyyy-MM-dd")
            dateParams.updateValue(date.toString(dateFormat: "yyyy-MM-dd"), forKey: "to_dt")
        }else{
            fromFeildLabel.text = date.stringFromFormat("yyyy-MM-dd")
            dateParams.updateValue(date.stringFromFormat("yyyy-MM-dd"), forKey: "from_dt")
        }
        NotificationCenter.default.post(name: NSNotification.Name("LoadingPaymentHistory"), object: nil, userInfo: dateParams)
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool{
        if datefrom == "to" {
            let order = NSCalendar.current.compare(Date(), to: date, toGranularity: .day)
            if order == .orderedDescending{
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    @objc func segmentValueChange(segment: UISegmentedControl){
        segment.isUserInteractionEnabled = false
        if segment.selectedSegmentIndex == 0 {
            invoiceAndHistory = "invoice"
            NotificationCenter.default.post(name: NSNotification.Name("LoadingInvoices"), object: nil)
            paymentHistoryContainerHeight.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.PaymentHistoryView.alpha = 0.0
                self.invoiceView.alpha = 1.0
                for i in self.paymentHistoryContainer.subviews {
                    i.alpha = 0.0
                }
                _ = [self.toLabel,self.fromLabel].map {  $0?.alpha = 0 }
                self.view.layoutIfNeeded()
            }
        }else{
            invoiceAndHistory = "PaymentHistory"
            NotificationCenter.default.post(name: NSNotification.Name("LoadingPaymentHistory"), object: nil, userInfo: dateParams)
            paymentHistoryContainerHeight.constant = 98
            UIView.animate(withDuration: 0.3) {
                self.invoiceView.alpha = 0.0
                self.PaymentHistoryView.alpha = 1.0
                for i in self.paymentHistoryContainer.subviews {
                    i.alpha = 1.0
                }
                _ = [self.toLabel,self.fromLabel].map {  $0?.alpha = 1.0 }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {        
                
        
        fromFeildContainer.layer.cornerRadius = 6
        fromFeildContainer.layer.masksToBounds = true
        fromFeildContainer.layer.borderWidth = 1.0
        fromFeildContainer.layer.borderColor = UIColor.black.cgColor
        
        toFeildContainer.layer.cornerRadius = 6
        toFeildContainer.layer.masksToBounds = true
        toFeildContainer.layer.borderWidth = 1.0
        toFeildContainer.layer.borderColor = UIColor.black.cgColor
        
        chooseUnitContainerView.layer.cornerRadius = 6
        chooseUnitContainerView.layer.masksToBounds = true
        chooseUnitContainerView.layer.borderWidth = 1.0
        chooseUnitContainerView.layer.borderColor = UIColor.black.cgColor
        
        chooseContainerTable.layer.shadowColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 0.4).cgColor
        chooseContainerTable.layer.shadowOpacity = 1
        chooseContainerTable.layer.shadowRadius = 12
        chooseContainerTable.layer.shadowOffset = CGSize(width: 0, height: 4)
        chooseContainerTable.layer.masksToBounds = false
        
    }
    
    func setupNoDues(){
        UIView.animate(withDuration: 0.5) {
            self.noDueGreen.alpha = 1.0
        } completion: { (compe) in
            UIView.animate(withDuration: 1.0) {[weak self] in
                self?.noDueRounded.alpha = 1.0
            } completion: { (compe) in
                self.noDueRounded.stopRotating()
                UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear, animations: {
                    self.noDueColored.alpha = 1.0
                    self.noDueColored.startRotating(duration: 0.5, repeatCount: 2, clockwise: true)
                    self.noDuesLable.alpha = 1.0
                   }) { finished in
                   }
            }
        }
    }
}

extension UIView {
    
    func startRotating(duration: CFTimeInterval = 3, repeatCount: Float = Float.infinity, clockwise: Bool = true) {
        if self.layer.animation(forKey: "transform.rotation.z") != nil {
            return
        }
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let direction = clockwise ? 1.0 : -1.0
        animation.toValue = NSNumber(value: .pi * 2 * direction)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        self.layer.add(animation, forKey:"transform.rotation.z")
    }
    
    func stopRotating() {
        
        self.layer.removeAnimation(forKey: "transform.rotation.z")
        
    }
}


extension Invoice_Payment_ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseUnitTableCell", for: indexPath) as? chooseUnitTableCell
        if let data = dropDownArray {
            cell?.unitName.text = data[indexPath.row].unitName
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if lastRowIndex != indexPath.row {
                cell?.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor(hex: "#BDBDBD"), width: 1.0)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            cell.alpha = 1
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(dropDownArray?[indexPath.row].selection ?? false) {
            dropDownArray?[indexPath.row].selection = true
        }else{
            dropDownArray?[indexPath.row].selection = false
        }
        self.chooseContainerTextLabel.text = dropDownArray?[indexPath.row].unitName
        UnitDetails.shared.unitID = "\(dropDownArray?[indexPath.row].unitID ?? 0)"
        UnitDetails.shared.unitName = "\(dropDownArray?[indexPath.row].unitName ?? "")"
        if invoiceAndHistory == "PaymentHistory" {
            NotificationCenter.default.post(name: NSNotification.Name("LoadingPaymentHistory"), object: nil, userInfo: dateParams)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name("LoadingInvoices"), object: nil)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.chooseContainerTable.delegate = nil
            self.chooseContainerTable.dataSource = nil
            self.chooseContainerTable.reloadData()
            self.chooseContainerDropDownImage.transform = self.chooseContainerDropDownImage.transform.rotated(by: -.pi / 2)
            self.chooseContainerTableHeight.constant = 0
            self.view.layoutIfNeeded()
        }, completion: {(value: Bool) in
            self.chooseDropDown.toggle()
        })
        
    }
}

struct dropDownSelection {
    var selection: Bool
    var unitName: String
    var unitID: Int
    init(selection: Bool, unitName: String, unitID:Int) {
        self.selection = selection
        self.unitName = unitName
        self.unitID = unitID
    }
}


extension UISegmentedControl {
    func ensureiOS12Style() {
        if #available(iOS 13, *) {
            let tintColorImage = UIImage(color: brandColor())
            // Must set the background image for normal to something (even clear) else the rest won't work
            setBackgroundImage(UIImage(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            setBackgroundImage(UIImage(color: tintColor.withAlphaComponent(0.2)), for: .highlighted, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
            
            let normalAttribute1: [NSAttributedString.Key: Any] = [.font: SFFont(font: .Semibold, size: 16), .foregroundColor: brandColor()]
            setTitleTextAttributes(normalAttribute1, for: .normal)
            //
            let normalAttribute: [NSAttributedString.Key: Any] = [.font: SFFont(font: .Semibold, size: 16), .foregroundColor: UIColor.white]
            setTitleTextAttributes(normalAttribute, for: .selected)
            
            setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderWidth = 1
            layer.borderColor = UIColor(hex: "#5445D3").cgColor
        }
    }
}
fileprivate extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
