//
//  SSMenuCell.swift
//  swagswap
//
//  Created by Logan Isitt on 3/5/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class SSMenuCell: UITableViewCell {
    
    enum MenuItem:Int {
        case Buy = 0, Sell, Watch, Inbox, Notification, Account, Default
    }
    
    @IBOutlet var title: UILabel!
    @IBOutlet var icon: UILabel!
    @IBOutlet var accessory: UILabel!
    
    
    var menuItem: MenuItem!
    var indentationLayer: CALayer!
    
    // MARK: - Initialization
    override init() {
        super.init()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    func setup() {

        defaults()
        
        indentationWidth = 10.0
        indentationLevel = 1
        
        indentationLayer = CALayer()
        indentationLayer.backgroundColor = UIColor.SSColor.Blue.CGColor
        layer.addSublayer(indentationLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if menuItem == nil {
            menuItem = .Default
        }
        
        title.text = getTitle(menuItem).uppercaseString
        title.textColor = UIColor.SSColor.Black
        title.textAlignment = NSTextAlignment.Left
        title.font = UIFont.SSFont.H3
        
        accessory.text = String.fontAwesomeIconWithName("fa-angle-right")
        accessory.textColor = UIColor.SSColor.Black
        accessory.textAlignment = NSTextAlignment.Right
        accessory.font = UIFont.fontAwesomeOfSize(30)
        
        icon.text = getIcon(menuItem)
        icon.textColor = UIColor.SSColor.Black
        icon.textAlignment = NSTextAlignment.Center
        icon.font = UIFont.fontAwesomeOfSize(30)
        
        indentationLayer.backgroundColor = getColor(menuItem).CGColor
    }
    
    // MARK: - Menu Item
    private func getTitle(mi: MenuItem) -> String {
        switch mi {
        case .Buy:          return "Buying"
        case .Sell:         return "Selling"
        case .Watch:        return "Watching"
        case .Inbox:        return "Inbox"
        case .Notification: return "Notifications"
        case .Account:      return "Account"
        default:            return ""
        }
    }
    
    private func getIcon(mi: MenuItem) -> String {
        switch mi {
        case .Buy:          return String.fontAwesomeIconWithName("fa-shopping-cart")
        case .Sell:         return String.fontAwesomeIconWithName("fa-tag")
        case .Watch:        return String.fontAwesomeIconWithName("fa-eye")
        case .Inbox:        return String.fontAwesomeIconWithName("fa-inbox")
        case .Notification: return String.fontAwesomeIconWithName("fa-bell")
        case .Account:      return String.fontAwesomeIconWithName("fa-cogs")
        default:            return ""
        }
    }
    
    private func getColor(mi: MenuItem) -> UIColor {
        switch mi {
        case .Buy:          return UIColor.SSColor.Yellow
        case .Sell:         return UIColor.SSColor.Red
        case .Watch:        return UIColor.SSColor.LightBlue
        case .Inbox:        return UIColor.SSColor.Blue
        case .Notification: return UIColor.SSColor.Aqua
        case .Account:      return UIColor.SSColor.Black
        default:            return UIColor.SSColor.Black
        }
    }
    
    // MARK: - Draw
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        indentationLayer.frame = CGRectMake(0, 0, indentationWidth, rect.height)
    }
    
    // MARK: - Defaults
    func defaults() {
        
        // Remove seperator inset
        if respondsToSelector("setSeparatorInset:") {
            separatorInset = UIEdgeInsetsZero
        }
        // Prevent the cell from inheriting the Table View's margin settings
        if respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            preservesSuperviewLayoutMargins = false
        }
        // Explictly set your cell's layout margins
        if respondsToSelector("setLayoutMargins:") {
            layoutMargins = UIEdgeInsetsZero
        }
    }
}
