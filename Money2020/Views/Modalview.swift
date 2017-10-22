//
//  FlowView.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

import UIKit
import Spring

public enum ShowAnimation {
    case SlideFromBottom
}

public enum DismissAnimation {
    case FadeOut
}

class ModalView: UIView {
    
    //Public variables (settings)
    var dismissCompletion: (() -> Void)?
    var overlayColor = UIColor.black.withAlphaComponent(0.65)
    var showAnimation = ShowAnimation.SlideFromBottom
    var dismissAnimation = DismissAnimation.FadeOut
    let showAnimationDuration = 0.4
    let dismissAnimationDuration = 0.4
    
    //Private variables
    private var overlay: UIView!
    private var modalView: UIView!
    
    // MARK: Public Methods
    
    init(view: UIView) {
        super.init(frame: view.frame)
        modalView = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlay.backgroundColor = overlayColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ModalView.dismiss))
        overlay.addGestureRecognizer(tapGesture)
        overlay.alpha = 0
        superview!.addSubview(overlay)
        superview?.bringSubview(toFront: overlay)
        
        SpringAnimation.springWithCompletion(duration: 0.2, animations: { 
            self.overlay.alpha = 1
        }, completion: { _ -> Void in
            if self.showAnimation == .SlideFromBottom {
                self.slideFromBottom()
            }
        })
        
    }
    
    @objc func dismiss() {
        if dismissAnimation == .FadeOut {
            fadeOut()
        }
    }
    
    // MARK: Private Methods
    
    private func slideFromBottom() {
        modalView.frame.origin.y = superview!.frame.maxY
        superview?.addSubview(modalView)
        superview?.bringSubview(toFront: modalView)
        SpringAnimation.springWithCompletion(duration: showAnimationDuration, animations: { 
            self.modalView.center = (self.superview?.center)!
        }, completion: { Void in
            
        })
    }
    
    private func fadeOut() {
        SpringAnimation.springWithCompletion(duration: dismissAnimationDuration, animations: { 
            self.modalView.alpha = 0
            self.overlay.alpha = 0
        }, completion: { _ -> Void in
            self.overlay.removeFromSuperview()
            self.modalView.removeFromSuperview()
            self.removeFromSuperview()
            if self.dismissCompletion != nil {
                self.dismissCompletion!()
            }
        })
    }
    
}

