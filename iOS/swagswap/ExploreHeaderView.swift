//
//  SSExploreHeaderView.swift
//  swagswap
//
//  Created by Logan Isitt on 3/11/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

protocol ExploreHeaderViewDelegate {
    func expandOrContractSection(section: Int)
}

class ExploreHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var icon: UILabel!
    @IBOutlet var accessory: UILabel!
    
    var titleText: String!
    var iconName: String!
    var color: String!
    var section: Int!
    
    var isExpanded: Bool!
    
    let indentationWidth = CGFloat(10)
    var indentationLayer: CALayer!
    
    var delegate: ExploreHeaderViewDelegate!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        
        contentView.backgroundColor = UIColor.clearColor()
        
        title = UILabel()
        addSubview(title)

        icon = UILabel()
        addSubview(icon)
        
        accessory = UILabel()
        addSubview(accessory)
        
        indentationLayer = CALayer()
        indentationLayer.backgroundColor = UIColor.SSColor.Blue.CGColor
        layer.addSublayer(indentationLayer)
        
        isExpanded = false
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.bounds.size
        
        icon.frame = CGRectMake(20, 0, size.height, size.height)
        accessory.frame = CGRectMake(size.width - size.height, 0, size.height, size.height)
        
        let tWidth = CGRectGetMinX(accessory.frame) - CGRectGetMaxX(icon.frame) - 16
        
        title.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 8, 0, tWidth, size.height)
        
        title.text = titleText
        title.textColor = UIColor.SSColor.Black
        title.textAlignment = NSTextAlignment.Left
        title.font = UIFont.SSFont.H3
        
        accessory.textColor = UIColor.SSColor.Black
        accessory.textAlignment = NSTextAlignment.Center
        accessory.font = UIFont.fontAwesomeOfSize(30)
        
        icon.text = String.fontAwesomeIconWithName(iconName)
        icon.textColor = UIColor.SSColor.Black
        icon.textAlignment = NSTextAlignment.Center
        icon.font = UIFont.fontAwesomeOfSize(30)
        
        indentationLayer.backgroundColor = UIColor(rgba: color).CGColor // SSColor.Yellow.CGColor
        
        if isExpanded == true {
            accessory.text = String.fontAwesomeIconWithName("fa-angle-down")
        }
        else {
            accessory.text = String.fontAwesomeIconWithName("fa-angle-right")
        }
    }
    
    // MARK: - Draw
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        indentationLayer.frame = CGRectMake(0, 0, indentationWidth, rect.height)
    }
    
    // MARK: - Actions 
    
    func handleTap(sender: UITapGestureRecognizer) {
        if (accessory.text == String.fontAwesomeIconWithName("fa-angle-right")) {
            
            accessory.text = String.fontAwesomeIconWithName("fa-angle-down")
        }
        else {
            accessory.text = String.fontAwesomeIconWithName("fa-angle-right")
        }
        delegate.expandOrContractSection(section)
    }
}
