//
//  CheckoutCardTableViewCell.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/21/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import UIKit

class CheckoutCardTableViewCell: UITableViewCell {
    
    var paymentInfoLabel: UILabel!
    var cardInfoLabel: UILabel!
    var icon: UIImageView!
    
    var pageControl: UIPageControl!
    var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "#FAFAFA")
        selectionStyle = .none
    
        let card1 = CheckoutCardSelectView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(card1)

        
        //        icon = UIImageView(frame: CGRect(x: 15, y: (frame.height - 25)/2, width: 25, height: 25))
        //        icon.image = UIImage(named: "card")?.withRenderingMode(.alwaysTemplate)
        //        icon.tintColor = UIColor(hex: "#989CA0")
        //        icon.contentMode = .scaleAspectFit
        //        contentView.addSubview(icon)
        //
        //        paymentInfoLabel = UILabel(frame: CGRect(x: icon.frame.maxX + 20, y: (frame.height - 41)/2, width: frame.width - 30, height: 18))
        //        paymentInfoLabel.font = UIFont(name: "SFUIText-Medium", size: 14)
        //        paymentInfoLabel.textColor = UIColor(hex: "#212A31")
        //        paymentInfoLabel.text = "Payment Method"
        //        contentView.addSubview(paymentInfoLabel)
        //
        //        cardInfoLabel = UILabel(frame: CGRect(x: paymentInfoLabel.frame.minX, y: paymentInfoLabel.frame.maxY + 5, width: frame.width - 15 - 10, height: 18))
        //        cardInfoLabel.font = UIFont(name: "SFUIText-Regular", size: 14)
        //        cardInfoLabel.textColor = UIColor(hex: "#212A31")
        //        contentView.addSubview(cardInfoLabel)
        
    }
    
    @objc func turnPage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}

extension CheckoutCardTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
