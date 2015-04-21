//
//  SSExploreCell.swift
//  swagswap
//
//  Created by Logan Isitt on 3/10/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

class ExploreCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var icon: UILabel!
    
    var color: String!
    
    var indentationLayer: CALayer!
    
    // MARK: - Initialization
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
        
//        title.text = getTitle(exploreItem).uppercaseString
        title.textColor = UIColor.SSColor.Black
        title.textAlignment = NSTextAlignment.Left
        title.font = UIFont.SSFont.H4
        
//        accessory.text = String.fontAwesomeIconWithName("fa-angle-right")
//        accessory.textColor = UIColor.SSColor.Black
//        accessory.textAlignment = NSTextAlignment.Right
//        accessory.font = UIFont.fontAwesomeOfSize(30)
        
//        icon.text = getIcon(exploreItem)
//        icon.textColor = UIColor.SSColor.Black
//        icon.textAlignment = NSTextAlignment.Center
//        icon.font = UIFont.fontAwesomeOfSize(30)
        
        indentationLayer.backgroundColor = UIColor(rgba: color).CGColor // getColor(exploreItem).CGColor
    }
    
//    // MARK: - Menu Item
//    private func getTitle(mi: ExploreItem) -> String {
//        switch mi {
//        case .Furniture:    return "Furniture"
//        case .Pets:         return "Pets"
//        case .Tech:         return "Tech"
//        case .Vehicle:      return "Cars & Trucks"
//        case .Jewelry:      return "Jewelry"
//        case .Tickets:      return "Tickets"
//        default:            return ""
//        }
//    }
//    
//    private func getIcon(mi: ExploreItem) -> String {
//        switch mi {
//        case .Furniture:    return String.fontAwesomeIconWithName("fa-bed")
//        case .Pets:         return String.fontAwesomeIconWithName("fa-paw")
//        case .Tech:         return String.fontAwesomeIconWithName("fa-mobile")
//        case .Vehicle:      return String.fontAwesomeIconWithName("fa-car")
//        case .Jewelry:      return String.fontAwesomeIconWithName("fa-diamond")
//        case .Tickets:      return String.fontAwesomeIconWithName("fa-ticket")
//        default:            return ""
//        }
//    }
//    
//    private func getColor(mi: ExploreItem) -> UIColor {
//        switch mi {
//        case .Furniture:    return UIColor.SSColor.Yellow
//        case .Pets:         return UIColor.SSColor.Red
//        case .Tech:         return UIColor.SSColor.Blue
//        case .Vehicle:      return UIColor.SSColor.LightBlue
//        case .Jewelry:      return UIColor.SSColor.Aqua
//        case .Tickets:      return UIColor.SSColor.Black
//        default:            return UIColor.SSColor.Black
//        }
//    }
    
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
