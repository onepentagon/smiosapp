//
//  NotificationController.swift
//  Smartility
//
//  Created by Mani on 8/21/20.
//  Copyright © 2020 com.loyaleapp.pro. All rights reserved.
//

import UIKit
import Kingfisher
import Toast_Swift
import AudioToolbox
import AVFoundation

class NotificationController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var personLogo: UIImageView!
    @IBOutlet weak var appLogoShaking: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var catagory: UILabel!
    @IBOutlet weak var maskLabel: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var temp_icon: UIImageView!
    @IBOutlet weak var face_icon: UIImageView!
    @IBOutlet weak var approveContainer: UIView!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var rejectContainer: UIView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var heightConstrainContainer: NSLayoutConstraint!
    @IBOutlet weak var maskBGView: UIView!
    
    var sound_Name = ""
    var timer: Timer?
    var oneTimeMessage = false
    private var audioPlayer: AVAudioPlayer?
    
    var delayShakeTimer: Timer?
    var count = 30
    
    @objc func dismissDelay() {
        print("delay")
        count = count-1
        if count == 0 {
            self.resetDataNotifications()
            self.dismiss(animated: true, completion: nil)
        }else{
            if count == 25 {
                self.view.makeToast("Please approve or reject", duration: 3.0, position: .bottom)
            }
        }
    }
    
    @objc func delayShake() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.appLogoShaking.shake()
    }
    
    
    func resetDataNotifications(){
        AudioServicesPlayAlertSound(SystemSoundID())
        self.delayShakeTimer?.invalidate()
        self.delayShakeTimer = nil
        self.timer?.invalidate()
        self.timer = nil
        self.audioPlayer = nil
//        self.audioPlayer?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetDataNotifications()
               
        if let sound_name = notificationSingletone.shared.payload?.notif_sound {
            if let path = Bundle.main.path(forResource: String(sound_name), ofType: "aiff") {
                let alertSound = URL(fileURLWithPath: path)
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try! AVAudioSession.sharedInstance().setActive(true)
                try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
                if let Player = audioPlayer {
                    Player.prepareToPlay()
                    Player.play()
                    self.appLogoShaking.shake()
                    self.delayShakeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissDelay), userInfo: nil, repeats: true)
                    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.delayShake), userInfo: nil, repeats: true)
                }
            }
        }
        
        temp_icon.image = UIImage(named: "temp_imag")
        face_icon.image = UIImage(named: "faceMask")        
        
        if let catStr = notificationSingletone.shared.payload?.visitor_cat, let visitorOrg
            = notificationSingletone.shared.payload?.visitor_org, visitorOrg != "" {
            self.catagory.text = catStr+" From "+visitorOrg
        }else{
            if notificationSingletone.shared.payload?.visitor_cat == "Daily Helper" {
                self.catagory.text = notificationSingletone.shared.payload?.Visitor_sub_cat
            }else{
                self.catagory.text = notificationSingletone.shared.payload?.visitor_cat
            }
        }
       
        
        
        if let nameStr = notificationSingletone.shared.payload?.visitor_name {
            self.name.text = nameStr
        }
        
        
        self.temp.text = notificationSingletone.shared.payload?.visitor_temp
        
        let maskBool = notificationSingletone.shared.payload?.is_visitor_mask_on
        
        if  maskBool == "null" || maskBool == "0" || maskBool == "false" {
            maskBGView.isHidden = true
            heightConstrainContainer.constant = 300
        }
        
        if let img = notificationSingletone.shared.payload?.visitor_img_url {
            let url = URL(string: EndPoint.imageURL+img)
            let processor = DownsamplingImageProcessor(size: self.personLogo.bounds.size)
            self.personLogo.kf.indicatorType = .activity
            self.personLogo.kf.setImage(
                with: url,
                placeholder: UIImage(named: "proflie_icon"),
                options: [
                    .processor(processor),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ], completionHandler:
                    {
                        result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                        }
                    })
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        
        imageContainer.layer.cornerRadius = imageContainer.frame.height/2
        imageContainer.layer.masksToBounds = true
        
        personLogo.layer.cornerRadius = personLogo.frame.height/2
        personLogo.layer.masksToBounds = true
        
        approveContainer.layer.cornerRadius = 6
        approveContainer.layer.masksToBounds = true
        approveBtn.layer.cornerRadius = 6
        approveBtn.layer.masksToBounds = true
        
        rejectContainer.layer.cornerRadius = 6
        rejectContainer.layer.masksToBounds = true
        rejectBtn.layer.cornerRadius = 6
        rejectBtn.layer.masksToBounds = true
                
        maskBGView.layer.cornerRadius = 6
        maskBGView.layer.masksToBounds = true
    }
    
    @IBAction func rejectBtn(_ sender: UIButton) {
        let perams = ["visit_id":notificationSingletone.shared.payload?.visit_id ?? "", "approval_user_id": notificationSingletone.shared.payload?.approval_user_id ?? ""]
        let alert = UIAlertController(title: "", message: "Are you sure, you want to deny the entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .destructive,
                                      handler: {(_: UIAlertAction!) in
                                        sender.loadingIndicator(true, .white, "")
                                        Networking.shared.rejectBtn(perams: perams) { (success, error) in
                                            if success != nil {
                                                NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                                                sender.loadingIndicator(false, .white, "Reject")
                                                self.view.makeToast("Thank you")
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                    
                                                    self.resetDataNotifications()
                                                    
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                                
                                            }
                                            if let er = error {
                                                NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                                                sender.loadingIndicator(false, .white, "Reject")
                                                self.showConfirmAlert(title: "", message: er.localizedDescription, buttonTitle: "Ok", buttonStyle: .default) { (action) in
                                                    self.resetDataNotifications()
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                            }
                                        }
                                        sender.loadingIndicator(false, .white, "Reject")
                                      }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func approveBtn(_ sender: UIButton) {
        sender.loadingIndicator(true, .white, "")
        let perams = ["visit_id":notificationSingletone.shared.payload?.visit_id ?? "", "approval_user_id": notificationSingletone.shared.payload?.approval_user_id ?? ""]
        Networking.shared.approve_btn(perams: perams) { (success, error) in
            if success != nil {
                sender.loadingIndicator(false, .white, "Approve")
                self.view.makeToast("Thank you")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                    self.resetDataNotifications()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            if let er = error {
                NotificationCenter.default.post(name: NSNotification.Name("UpdateActions"), object: nil)
                sender.loadingIndicator(false, .white, "Approve")
                self.showConfirmAlert(title: "", message: er.localizedDescription, buttonTitle: "Ok", buttonStyle: .default) { (action) in
                    self.resetDataNotifications()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            sender.loadingIndicator(false, .white, "Approve")
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.resetDataNotifications()
    }
    
}



extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        self.layer.add(animation, forKey: "shake")
    }
}
