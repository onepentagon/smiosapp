//
//  Uttiles.swift
//  Smartility
//
//  Created by Mani on 7/6/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import Foundation
import UIKit




extension UIViewController {
    func showConfirmAlert(title: String?, message: String?, buttonTitle: String, buttonStyle: UIAlertAction.Style, confirmAction: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle, handler:confirmAction))
        present(alert, animated: true, completion: nil)
    }
}

final class CustomButton: UIButton {

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

//        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 35).cgPath
//            if self.backgroundColor != nil {
//                shadowLayer.fillColor = self.backgroundColor?.cgColor
//            }
//            else{
//                shadowLayer.fillColor = UIColor(hex: "#E26557").cgColor
//            }            
//            shadowLayer.shadowColor = UIColor.gray.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//            shadowLayer.shadowOpacity = 0.4
//            shadowLayer.shadowRadius = 2
//            layer.insertSublayer(shadowLayer, at: 0)
//        }

    }

}


extension UIView {
    func createShadowLayer() -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor(red: 0.333, green: 0.184, blue: 0.933, alpha: 0.12).cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        shadowLayer.shadowRadius = 10.0
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        return shadowLayer
    }
    
    func makeCustomRound(shadow: Bool,backgroundColor: UIColor, topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY

        let path = UIBezierPath()
        path.move(to: CGPoint(x: minX + topLeft, y: minY))
        path.addLine(to: CGPoint(x: maxX - topRight, y: minY))
        path.addArc(withCenter: CGPoint(x: maxX - topRight, y: minY + topRight), radius: topRight, startAngle:CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: maxX, y: maxY - bottomRight))
        path.addArc(withCenter: CGPoint(x: maxX - bottomRight, y: maxY - bottomRight), radius: bottomRight, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        path.addLine(to: CGPoint(x: minX + bottomLeft, y: maxY))
        path.addArc(withCenter: CGPoint(x: minX + bottomLeft, y: maxY - bottomLeft), radius: bottomLeft, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        path.addLine(to: CGPoint(x: minX, y: minY + topLeft))
        path.addArc(withCenter: CGPoint(x: minX + topLeft, y: minY + topLeft), radius: topLeft, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
        path.close()
        
        let line = CAShapeLayer()
        line.path = path.cgPath
        line.fillColor = backgroundColor.cgColor
        
        if shadow {
            line.shadowColor = UIColor(red: 0.333, green: 0.184, blue: 0.933, alpha: 0.12).cgColor
            line.shadowOffset = CGSize(width: 0, height: 4)
            line.shadowRadius = 10.0
            line.shadowOpacity = 0.8
            line.backgroundColor = UIColor.clear.cgColor
        }
        if let layers = layer.sublayers {
            for layer in layers {
                if layer.isKind(of: CAShapeLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        layer.addSublayer(line)
    }
}



extension UIButton {
    private func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }
    
    func actionHandle(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        self.actionHandleBlock(action: action)
        self.addTarget(self, action: #selector(self.triggerActionHandleBlock), for: control)
    }
}



public enum CAGradientPoint {
    case topLeft
    case centerLeft
    case bottomLeft
    case topCenter
    case center
    case bottomCenter
    case topRight
    case centerRight
    case bottomRight
    var point: CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: 0, y: 0)
        case .centerLeft:
            return CGPoint(x: 0, y: 0.5)
        case .bottomLeft:
            return CGPoint(x: 0, y: 1.0)
        case .topCenter:
            return CGPoint(x: 0.5, y: 0)
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .bottomCenter:
            return CGPoint(x: 0.5, y: 1.0)
        case .topRight:
            return CGPoint(x: 1.0, y: 0.0)
        case .centerRight:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottomRight:
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

extension CAGradientLayer {

    convenience init(start: CAGradientPoint, end: CAGradientPoint, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.frame.origin = CGPoint.zero
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}

extension UIView {

    func layerGradient(startPoint:CAGradientPoint, endPoint:CAGradientPoint ,colorArray:[CGColor], type:CAGradientLayerType ) {
        let gradient = CAGradientLayer(start: .topLeft, end: .topRight, colors: colorArray, type: type)
        gradient.frame.size = self.frame.size
        self.layer.insertSublayer(gradient, at: 0)
    }
}


extension UITableView {
    
    enum scrollsTo {
        case top,bottom
    }
    class CustomLabel: UILabel{
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)))
        }
    }
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 50))
        messageLabel.text = message
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "SFUIText-Regular", size: 17)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(_ animated: Bool = false) {
        let indexPath = IndexPath(row: 0, section: 0)
        if hasRowAtIndexPath(indexPath: indexPath) {
            scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}

extension UITextField {
    //MARK:- Set Image on the right of text fields
    func setupRight_icon(imageName:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
    }
}



extension UITableView {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                let activityView = UIActivityIndicatorView(style: .medium)
                self.backgroundView = activityView
                activityView.startAnimating()
            } else {
                let activityView = UIActivityIndicatorView.init(style: .whiteLarge)
                self.backgroundView = activityView
                activityView.startAnimating()
            }
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}


extension UIPopoverPresentationController {
    
    var dimmingView: UIView? {
        return value(forKey: "_dimmingView") as? UIView
    }
}

extension UIView {
    func addTopLabel(labelText: String,contreoller: UIViewController)->UILabel{
        let topLabel = UILabel()
        contreoller.view.addSubview(topLabel)
        let widthText = width(text: labelText, height: 14.5)+20
        topLabel.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, centerX: nil, centerY: nil, paddingTop: -7, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: widthText, height: 14.5, enableInsets: true)
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 12)
        topLabel.textColor = .lightGray
        topLabel.text = labelText
        topLabel.backgroundColor = .white
        bringSubviewToFront(topLabel)
        return topLabel
    }
    func width(text: String, height: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let constraintBox = CGSize(width: .greatestFiniteMagnitude, height: height)
        let textWidth = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).width.rounded(.up)

        return textWidth
    }
}



class CustomDateFormatter {

    // MARK: - Properties
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = .current
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }

    // MARK: - Public
    static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }

    static func campareToday(_ string: String, with date: Date = Date()) -> Bool {
        guard let newDate = dateFormatter.date(from: string) else {
            return false
        }
        return newDate == date
    }
    
    static func campareYesterDay(_ string: String, with date: Date = Date.yesterday()) -> Bool {
        guard let newDate = dateFormatter.date(from: string) else {
            return false
        }
        return newDate < date
    }
}
extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}



extension UIButton {
    
    private class Action {
        var action: (UIButton) -> Void
        
        init(action: @escaping (UIButton) -> Void) {
            self.action = action
        }
    }
    
    private struct AssociatedKeys {
        static var ActionTapped = "actionTapped"
    }
    
    private var tapAction: Action? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionTapped, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionTapped) as? Action }
    }
    
    
    @objc dynamic private func handleAction(_ recognizer: UIButton) {
        tapAction?.action(recognizer)
    }
    
    
    func mk_addTapHandler(action: @escaping (UIButton) -> Void) {
        self.addTarget(self, action: #selector(handleAction(_:)), for: .touchUpInside)
        tapAction = Action(action: action)
        
    }
}


final class ClickListener: UITapGestureRecognizer {
    private var action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}


extension UIView {
    func setClickListener(_ action: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        let click = ClickListener(action)
        self.addGestureRecognizer(click)
    }
}

extension UIGestureRecognizer {
    
    typealias Action = ((UIGestureRecognizer) -> ())
    
    private struct Keys {
        static var actionKey = "ActionKey"
    }
    
    private var block: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &Keys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        get {
            let action = objc_getAssociatedObject(self, &Keys.actionKey) as? Action
            return action
        }
    }
    
    @objc func handleAction(recognizer: UIGestureRecognizer) {
        block?(recognizer)
    }
    
    convenience public  init(block: @escaping ((UIGestureRecognizer) -> ())) {
        self.init()
        self.block = block
        self.addTarget(self, action: #selector(handleAction(recognizer:)))
    }
}

extension Date {
    static var yesterdayData: Date { return Date().dayBefore }
    static var tomorrowDate:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var monthOF: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeekDate: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func toString( dateFormat format : String ) -> String
       {
           let dateFormatter = DateFormatter()        
           dateFormatter.dateFormat = format
           return dateFormatter.string(from: self)
       }
}


func getTopWindow()->UIWindow? {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    } else {
        if let window = UIApplication.shared.windows.first(where: { (window) -> Bool in window.isKeyWindow}) {
            return window
        }else{
            return nil
        }
    }
}

extension UITextField{
    
    
    
    func setLeftPaddingPoints(_ space: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}


extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func layoutAnchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, centerX : NSLayoutXAxisAnchor?, centerY : NSLayoutYAxisAnchor? ,paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0.0)
        var bottomInset = CGFloat(0.0)
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if let centerX = centerX{
            centerXAnchor.constraint(equalTo: centerX, constant: 0.0).isActive = true
        }
        if let centerY = centerY{
            centerYAnchor.constraint(equalTo: centerY, constant: 0.0).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    

        
        func makeConstraints(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, topMargin: CGFloat, leftMargin: CGFloat, rightMargin: CGFloat, bottomMargin: CGFloat, width: CGFloat, height: CGFloat) {
            
            self.translatesAutoresizingMaskIntoConstraints = false
            if let top = top {
                self.topAnchor.constraint(equalTo: top, constant: topMargin).isActive = true
            }
            
            if let left = left {
                self.leftAnchor.constraint(equalTo: left, constant: leftMargin).isActive = true
            }
            
            if let right = right {
                self.rightAnchor.constraint(equalTo: right, constant: -rightMargin).isActive = true
            }
            
            if let bottom = bottom {
                self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomMargin).isActive = true
            }
            
            if width != 0 {
                self.widthAnchor.constraint(equalToConstant: width).isActive = true
            }
            
            if height != 0 {
                self.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
        }
        
        func addSubviews(_ views: UIView...) {
            views.forEach{ addSubview($0) }
        }
    

}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.removeFirst() }
        
        if ((cString.count) != 6) {
            self.init(hex: "ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}

extension UIButton {
    func loadingIndicator(_ show: Bool,_ color: UIColor,_ title: String) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.color = color
            self.setTitle(title, for: .normal)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            DispatchQueue.main.async {
                self.isEnabled = true
                self.alpha = 1.0
                if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                    self.setTitle(title, for: .normal)
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
        }
    }
}




enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

extension UIView {
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}


extension UITextField {
    
    //MARK:- Set Image on the right of text fields
    
    func setupRightImage(imageName:String, color: UIColor = .black){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 8, width: 25, height: 25))
        imageView.image = UIImage(named: imageName)?.imageWithColor(color1: color)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
    }
    
    
    func setupInvoiceRightImage(imageName:String,color: UIColor = .black){
        let imageView = UIImageView(frame: CGRect(x: 35, y: 0, width: 18, height: 20))
        imageView.image = UIImage(named: imageName)?.imageWithColor(color1: color)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 20))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
    }
    
    
    //MARK:- Set Image on left of text fields
    
    func setupLeftImage(imageName:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        leftView = imageContainerView
        leftViewMode = .always
        self.tintColor = .lightGray
    }
    
    func setupExpirryRightImage(imageName:String, color: UIColor = .black){
           let imageView = UIImageView(frame: CGRect(x: 0, y: 8, width: 25, height: 25))
        imageView.image = UIImage(named: imageName)?.imageWithColor(color1: color)
           let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
           imageContainerView.addSubview(imageView)
           rightView = imageContainerView
           rightViewMode = .always
           self.tintColor = .lightGray
       }
    
}


extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
extension UITableView {   
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.3, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

public extension UIDevice {

    /// pares the deveice name as the standard name
    var modelName: String {

        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPod9,1":                                 return "iPod touch (7th generation)"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE (2nd generation)"
        case "iPhone13,1":                              return "iPhone 12 mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }
}

extension UIView {

   func roundCorners(
      corners: UIRectCorner,
      radius: CGFloat
   ) {
      let path = UIBezierPath(
         roundedRect: bounds,
         byRoundingCorners: corners,
         cornerRadii: CGSize(
            width: radius,
            height: radius
         )
      )

      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
   }
}
extension UIView{
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        
        self.backgroundColor = UIColor.clear
        let roundedShapeLayer = CAShapeLayer()
        let roundedMaskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius, view: self)
                        
        roundedShapeLayer.frame = self.bounds
        roundedShapeLayer.fillColor = accentColor().cgColor
        roundedShapeLayer.path = roundedMaskPath.cgPath
        
        self.layer.insertSublayer(roundedShapeLayer, at: 0)
        
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowColor = UIColor.lightGray.cgColor
        
//        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        layer.mask = shape
    
        
//        layer.insertSublayer(shapeLayer, below: 0)
//        layer.insertSublayer(shapeLayer, above: 0)
    }
}
extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero, view: UIView){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
//        let value = view.frame.width-72//view.frame.width/4.2
        var xPos = CGFloat()
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                xPos = view.frame.width-view.frame.width/2.8
            case 1334:
                print("iPhone 6/6S/7/8")
                xPos = view.frame.width-view.frame.width/4.2
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                xPos = view.frame.width-72
            case 2436:
                print("iPhone X/XS/11 Pro")
                xPos = view.frame.width-view.frame.width/4.2
            case 2688:
                print("iPhone XS Max/11 Pro Max")
                xPos = view.frame.width-72
            case 1792:
                print("iPhone XR/ 11 ")
                xPos = view.frame.width-72
            case 2532:
                print("iPhone 12/ iPhone 12 Pro")
                xPos = view.frame.width-view.frame.width/4.8
            case 2778:
                print("iPhone 12 Pro Max")
                xPos = view.frame.width-60
            default:
                xPos = view.frame.width-72
            }
        }
        
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        if topRightRadius != .zero{
                        
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
             path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }

        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }

        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }

        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        path.closeSubpath()
        cgPath = path
    }
}


@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil,customVIew:UIView) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            customVIew.addSubview(child.view)
        }, completion: nil)
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.view.alpha = 0.0
        }) { (completion) in
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
}


extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}



protocol KeyboardNotificationsDelegate: class {
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
    func keyboardDidShow(notification: NSNotification)
    func keyboardDidHide(notification: NSNotification)
}

extension KeyboardNotificationsDelegate {
    func keyboardWillShow(notification: NSNotification) {}
    func keyboardWillHide(notification: NSNotification) {}
    func keyboardDidShow(notification: NSNotification) {}
    func keyboardDidHide(notification: NSNotification) {}
}

class KeyboardNotifications {

    fileprivate var _isEnabled: Bool
    fileprivate var notifications: [NotificationType]
    fileprivate weak var delegate: KeyboardNotificationsDelegate?
    fileprivate(set) lazy var isKeyboardShown: Bool = false

    init(notifications: [NotificationType], delegate: KeyboardNotificationsDelegate) {
        _isEnabled = false
        self.notifications = notifications
        self.delegate = delegate
    }

    deinit { if isEnabled { isEnabled = false } }
}

extension UIView {
    func findFirstResponderSubview() -> UIView? { getAllSubviews().first { $0.isFirstResponder } }
    func getAllSubviews<T: UIView>() -> [T] { UIView.getAllSubviews(from: self) as [T] }
    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }
}
extension UIScrollView {
    func scrollVerticallyToFirstResponderSubview(keyboardFrameHight: CGFloat) {
        guard let firstResponderSubview = findFirstResponderSubview() else { return }
        scrollVertically(toFirstResponder: firstResponderSubview,
                         keyboardFrameHight: keyboardFrameHight, animated: true)
    }
    
    private func scrollVertically(toFirstResponder view: UIView,
                                  keyboardFrameHight: CGFloat, animated: Bool) {
        let scrollViewVisibleRectHeight = frame.height - keyboardFrameHight
        let maxY = contentSize.height - scrollViewVisibleRectHeight
        if contentOffset.y >= maxY { return }
        var point = view.convert(view.bounds.origin, to: self)
        point.x = 0
        point.y -= scrollViewVisibleRectHeight/2
        if point.y > maxY {
            point.y = maxY
        } else if point.y < 0 {
            point.y = 0
        }
        setContentOffset(point, animated: true)
    }
}

// MARK: - enums

extension KeyboardNotifications {

    enum NotificationType {
        case willShow, willHide, didShow, didHide

        var selector: Selector {
            switch self {
                case .willShow: return #selector(keyboardWillShow(notification:))
                case .willHide: return #selector(keyboardWillHide(notification:))
                case .didShow: return #selector(keyboardDidShow(notification:))
                case .didHide: return #selector(keyboardDidHide(notification:))
            }
        }

        var notificationName: NSNotification.Name {
            switch self {
                case .willShow: return UIResponder.keyboardWillShowNotification
                case .willHide: return UIResponder.keyboardWillHideNotification
                case .didShow: return UIResponder.keyboardDidShowNotification
                case .didHide: return UIResponder.keyboardDidHideNotification
            }
        }
    }
}

// MARK: - isEnabled

extension KeyboardNotifications {

    private func addObserver(type: NotificationType) {
        NotificationCenter.default.addObserver(self, selector: type.selector, name: type.notificationName, object: nil)
    }

    var isEnabled: Bool {
        set {
            if newValue {
                for notificaton in notifications { addObserver(type: notificaton) }
            } else {
                NotificationCenter.default.removeObserver(self)
            }
            _isEnabled = newValue
        }

        get { _isEnabled }
    }

}

// MARK: - Notification functions

extension KeyboardNotifications {

    @objc func keyboardWillShow(notification: NSNotification) {
        delegate?.keyboardWillShow(notification: notification)
        isKeyboardShown = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        delegate?.keyboardWillHide(notification: notification)
        isKeyboardShown = false
    }

    @objc func keyboardDidShow(notification: NSNotification) {
        isKeyboardShown = true
        delegate?.keyboardDidShow(notification: notification)
    }

    @objc func keyboardDidHide(notification: NSNotification) {
        isKeyboardShown = false
        delegate?.keyboardDidHide(notification: notification)
    }
}
