//
//  StatusView.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

import DGActivityIndicatorView
import Spring

class StatusView: UIView {
    
    private var activityIndicator: DGActivityIndicatorView!
    private var sentLabel: UILabel!
    private var overlayView: UIView!
    let semaphore = DispatchSemaphore(value: 1)
    var dismissAvailable = true
    
    init() {
        super.init(frame: CGRect(x: (UIScreen.main.bounds.width - 150)/2, y: (UIScreen.main.bounds.height - 120)/2, width: 150, height: 60))
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 6
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
        activityIndicator = DGActivityIndicatorView(type: .ballPulse, tintColor: UIColor.gray)
        activityIndicator.alpha = 0
        activityIndicator.size = 60
        activityIndicator.frame = CGRect(x: (frame.width - 60)/2, y: (frame.height - 40)/2, width: 60, height: 40)
        addSubview(activityIndicator)
        bringSubview(toFront: activityIndicator)
        
        sentLabel = UILabel(frame: CGRect(x: 5, y: activityIndicator.frame.maxY + 5, width: frame.width - 10, height: 30))
        sentLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        sentLabel.textAlignment = .center
        sentLabel.textColor = .darkGray
        sentLabel.alpha = 0
        sentLabel.lineBreakMode = .byWordWrapping
        sentLabel.numberOfLines = 0
        addSubview(sentLabel)
        
        overlayView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(inView: UIView) {
        frame =  CGRect(x: (UIScreen.main.bounds.width - 150)/2, y: (UIScreen.main.bounds.height - 120)/2, width: 150, height: 60)
        alpha = 1
        inView.addSubview(overlayView)
        inView.addSubview(self)
        inView.bringSubview(toFront: self)
        activityIndicator.startAnimating()
        SpringAnimation.springEaseIn(duration: 0.4, animations: { _ in
            self.activityIndicator.alpha = 1
            self.overlayView.alpha = 0.5
        })
    }
    
    func displayMessage(text: String) {
        SpringAnimation.springEaseInOut(duration: 0.4, animations: { _ in
            self.sentLabel.text = text
            self.sentLabel.alpha = 1
            self.sentLabel.sizeToFit()
            self.sentLabel.frame = CGRect(x: 5, y: self.activityIndicator.frame.maxY + 5, width: self.frame.width - 10, height: self.sentLabel.frame.height)
            self.frame = CGRect(x: (UIScreen.main.bounds.width - 150)/2, y: (UIScreen.main.bounds.height - 160)/2, width: 150, height: self.sentLabel.frame.height + 70)
        })
    }
    
    func hideAfter(delay: Double, completion: (() -> Void)?) {
        if !dismissAvailable {
            return
        }
        semaphore.wait(timeout: .now() + .seconds(5))
        dismissAvailable = false
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { _ in
            
            SpringAnimation.springWithCompletion(duration: 0.4, animations: { _ in
                self.alpha = 0
                self.activityIndicator.alpha = 0
                self.sentLabel.alpha = 0
                self.overlayView.alpha = 0
                self.activityIndicator.stopAnimating()
                
            }, completion: { _ in
                self.overlayView.removeFromSuperview()
                self.sentLabel.removeFromSuperview()
                self.removeFromSuperview()
                self.dismissAvailable = true
                self.semaphore.signal()
                if completion != nil {
                    completion!()
                }
            })
        })
    }
    
}

