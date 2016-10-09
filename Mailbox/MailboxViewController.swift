//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Mullins, Griffin on 10/8/16.
//  Copyright © 2016 Mullins, Griffin. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var messageParentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var remindImage: UIImageView!
    @IBOutlet weak var archiveImage: UIImageView!
    
    let animationDuration: Double! = 0.25
    let mainViewOffset: CGFloat! = 290
    
    var ogMessageX: CGFloat!
    var ogRemindX: CGFloat!
    var ogArchiveX: CGFloat!
    var ogMainViewX: CGFloat!
    var messageX: CGFloat!
    var remindX: CGFloat!
    var archiveX: CGFloat!
    var mainViewX: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.contentSize.height = feedImage.frame.origin.y + feedImage.frame.height
        
        ogMessageX = messageImage.frame.origin.x
        ogRemindX = remindImage.frame.origin.x
        ogArchiveX = archiveImage.frame.origin.x
        ogMainViewX = mainView.frame.origin.x
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake && messageParentView.isHidden == true {
            print("Shaken, not stirred")
            UIView.animate(withDuration: animationDuration, animations: {
                self.messageParentView.isHidden = false
                self.messageParentView.frame.origin.y += self.messageParentView.frame.height
                self.feedImage.frame.origin.y += self.messageParentView.frame.height
                }, completion: { (Bool) in
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        self.messageImage.frame.origin.x = self.ogMessageX
                        self.remindImage.frame.origin.x = self.ogRemindX
                        self.archiveImage.frame.origin.x = self.ogArchiveX
                        self.messageParentView.backgroundColor = #colorLiteral(red: 0.7882353663, green: 0.8078430891, blue: 0.8235294223, alpha: 1)
                        }, completion: { (Bool) in
                            self.archiveImage.isHidden = false
                            self.remindImage.isHidden = false
                            self.remindImage.image! = #imageLiteral(resourceName: "later_icon")
                            self.archiveImage.image = #imageLiteral(resourceName: "archive_icon")
                    })
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func panOnMessage(_ sender: AnyObject) {
        //panned on message
        let translation = sender.translation(in: messageImage).x
        let rightOffset: CGFloat! = -70
        let leftOffset: CGFloat! = 70
        let farRightOffset: CGFloat! = -200
        let farLeftOffset: CGFloat! = 200
        
        print("panned on message \(translation)")
        
        if sender.state == .began {
            messageX = messageImage.frame.origin.x
            remindX = remindImage.frame.origin.x
            archiveX = archiveImage.frame.origin.x
            
            remindImage.alpha = 0
            archiveImage.alpha = 0
            
        } else if sender.state == .changed {
            messageImage.frame.origin.x = messageX + translation
            
            UIView.animate(withDuration: self.animationDuration, animations: {
                if translation < farRightOffset {
                    self.messageParentView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.remindImage.frame.origin.x = self.remindX + translation - rightOffset
                    self.remindImage.image! = #imageLiteral(resourceName: "list_icon")
                } else if translation < rightOffset {
                    self.messageParentView.backgroundColor = #colorLiteral(red: 1, green: 0.8627450466, blue: 0.1411764026, alpha: 1)
                    self.remindImage.frame.origin.x = self.remindX + translation - rightOffset
                    self.remindImage.image! = #imageLiteral(resourceName: "later_icon")
                    self.remindImage.alpha = 1
                } else if translation < leftOffset {
                    self.messageParentView.backgroundColor = #colorLiteral(red: 0.7882353663, green: 0.8078430891, blue: 0.8235294223, alpha: 1)
                    self.remindImage.frame.origin.x = self.ogRemindX
                    self.archiveImage.frame.origin.x = self.ogArchiveX
                } else if translation < farLeftOffset {
                    self.messageParentView.backgroundColor = #colorLiteral(red: 0.05490205437, green: 0.6352941394, blue: 0.0941176191, alpha: 1)
                    self.archiveImage.frame.origin.x = self.archiveX + translation - leftOffset
                    self.archiveImage.image = #imageLiteral(resourceName: "archive_icon")
                    self.archiveImage.alpha = 1
                } else if translation > farLeftOffset {
                    self.messageParentView.backgroundColor = #colorLiteral(red: 0.8156864047, green: 0.1882352531, blue: 0.1529411376, alpha: 1)
                    self.archiveImage.frame.origin.x = self.archiveX + translation - leftOffset
                    self.archiveImage.image = #imageLiteral(resourceName: "delete_icon")
                }
                }, completion: { (Bool) in
                }
            )
            
        } else if sender.state == .ended {
            UIView.animate(withDuration: self.animationDuration, animations: {
                
                if translation < farRightOffset {
                    self.messageImage.frame.origin.x = self.messageImage.frame.width * -1
                    self.archiveImage.isHidden = true
                    self.remindImage.frame.origin.x = self.messageImage.frame.width * -1
                } else if translation < rightOffset {
                    self.messageImage.frame.origin.x = self.messageImage.frame.width * -1
                    self.archiveImage.isHidden = true
                    self.remindImage.frame.origin.x = self.messageImage.frame.width * -1
                } else if translation < leftOffset {
                    self.messageImage.frame.origin.x = self.ogMessageX
                    self.remindImage.frame.origin.x = self.ogRemindX
                    self.archiveImage.frame.origin.x = self.ogArchiveX
                } else if translation < farLeftOffset {
                    self.messageImage.frame.origin.x = self.messageImage.frame.width
                    self.remindImage.isHidden = true
                    self.archiveImage.frame.origin.x = self.messageImage.frame.width
                } else if translation > farLeftOffset {
                    self.messageImage.frame.origin.x = self.messageImage.frame.width
                    self.remindImage.isHidden = true
                    self.archiveImage.frame.origin.x = self.messageImage.frame.width
                }
                }, completion: { (Bool) in
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        if translation < farRightOffset {
                            self.listImage.alpha = 1
                        } else if translation < rightOffset {
                            self.rescheduleImage.alpha = 1
                        } else if translation < leftOffset {
                        } else if translation < farLeftOffset {
                            self.messageParentView.frame.origin.y -= self.messageParentView.frame.height
                            self.feedImage.frame.origin.y -= self.messageParentView.frame.height
                        } else if translation > farLeftOffset {
                            self.messageParentView.frame.origin.y -= self.messageParentView.frame.height
                            self.feedImage.frame.origin.y -= self.messageParentView.frame.height
                        }
                        }, completion: {(Bool) in
                            if translation > leftOffset {
                                self.messageParentView.isHidden = true
                            }
                        }
                    )
                }
            )
        }
    }
    
    @IBAction func tapScreen(_ sender: AnyObject) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.listImage.alpha = 0
            self.rescheduleImage.alpha = 0
        }) { (Bool) in
            if self.messageImage.frame.origin.x != self.ogMessageX {
                UIView.animate(withDuration: self.animationDuration, animations: {
                    self.messageParentView.frame.origin.y -= self.messageParentView.frame.height
                    self.feedImage.frame.origin.y -= self.messageParentView.frame.height
                    }, completion: {(Bool) in
                        self.messageParentView.isHidden = true
                    }
                )
            }
        }
        
        if mainView.frame.origin.x != 0 {
            animateHamburger(open: true)
        }
    }
    
    @IBAction func panEdge(_ sender: AnyObject) {
        let translation = sender.translation(in: view).x
        let velocity = sender.velocity(in: view).x
        
        if sender.state == .began {
            mainViewX = mainView.frame.origin.x
        } else if sender.state == .changed {
            mainView.frame.origin.x = mainViewX + translation
        } else if sender.state == .ended {
            if velocity > 0 {
                animateHamburger(open: true)
            } else {
                animateHamburger(open: false)
            }
            
        }
    }
    
    @IBAction func tapHamburger(_ sender: AnyObject) {
        //print("tapped hamburger")
        if self.mainView.frame.origin.x == 0 {
            animateHamburger(open: true)
        } else {
            animateHamburger(open: false)
        }
    }
    
    func animateHamburger(open: Bool){
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            if open {
                self.mainView.frame.origin.x = self.mainViewOffset
            } else {
                self.mainView.frame.origin.x = 0
            }
            
        }) { (Bool) in
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

