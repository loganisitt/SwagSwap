//
//  SSExploreHeaderView.swift
//  swagswap
//
//  Created by Logan Isitt on 3/11/15.
//  Copyright (c) 2015 Logan Isitt. All rights reserved.
//

import UIKit

protocol SSExploreHeaderViewDelegate {
    func expandOrContractSection(section: Int)
}

class SSExploreHeaderView: UITableViewHeaderFooterView {
    
    enum ExploreItem:Int {
        case Pets = 0, Vehicle, Tech, Furniture, Jewelry, Tickets, Default
    }
    
    @IBOutlet var title: UILabel!
    @IBOutlet var icon: UILabel!
    @IBOutlet var accessory: UILabel!
    
    var exploreItem: ExploreItem!
    var isExpanded: Bool!
    
    let indentationWidth = CGFloat(10)
    var indentationLayer: CALayer!
    
    var delegate: SSExploreHeaderViewDelegate!
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setup()
    }
    
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
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.bounds.size
        
        icon.frame = CGRectMake(20, 0, size.height, size.height)
        accessory.frame = CGRectMake(size.width - size.height, 0, size.height, size.height)
        
        let tWidth = CGRectGetMinX(accessory.frame) - CGRectGetMaxX(icon.frame) - 16
        
        title.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 8, 0, tWidth, size.height)
        
        if exploreItem == nil {
            exploreItem = .Default
        }
        
        title.text = getTitle(exploreItem).uppercaseString
        title.textColor = UIColor.SSColor.Black
        title.textAlignment = NSTextAlignment.Left
        title.font = UIFont.SSFont.H3
        
        accessory.textColor = UIColor.SSColor.Black
        accessory.textAlignment = NSTextAlignment.Center
        accessory.font = UIFont.fontAwesomeOfSize(30)
        
        icon.text = getIcon(exploreItem)
        icon.textColor = UIColor.SSColor.Black
        icon.textAlignment = NSTextAlignment.Center
        icon.font = UIFont.fontAwesomeOfSize(30)
        
        indentationLayer.backgroundColor = getColor(exploreItem).CGColor
        
        if isExpanded == true {
            accessory.text = String.fontAwesomeIconWithName("fa-angle-down")
        }
        else {
            accessory.text = String.fontAwesomeIconWithName("fa-angle-right")
        }
    }
    
    // MARK: - Explore Item
    private func getTitle(mi: ExploreItem) -> String {
        switch mi {
        case .Furniture:    return "Furniture"
        case .Pets:         return "Pets"
        case .Tech:         return "Tech"
        case .Vehicle:      return "Cars & Trucks"
        case .Jewelry:      return "Jewelry"
        case .Tickets:      return "Tickets"
        default:            return ""
        }
    }
    
    private func getIcon(mi: ExploreItem) -> String {
        switch mi {
        case .Furniture:    return String.fontAwesomeIconWithName("fa-bed")
        case .Pets:         return String.fontAwesomeIconWithName("fa-paw")
        case .Tech:         return String.fontAwesomeIconWithName("fa-mobile")
        case .Vehicle:      return String.fontAwesomeIconWithName("fa-car")
        case .Jewelry:      return String.fontAwesomeIconWithName("fa-diamond")
        case .Tickets:      return String.fontAwesomeIconWithName("fa-ticket")
        default:            return ""
        }
    }
    
    private func getColor(mi: ExploreItem) -> UIColor {
        switch mi {
        case .Furniture:    return UIColor.SSColor.Yellow
        case .Pets:         return UIColor.SSColor.Red
        case .Tech:         return UIColor.SSColor.Blue
        case .Vehicle:      return UIColor.SSColor.LightBlue
        case .Jewelry:      return UIColor.SSColor.Aqua
        case .Tickets:      return UIColor.SSColor.Black
        default:            return UIColor.SSColor.Black
        }
    }
    
    // MARK: - Draw
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        indentationLayer.frame = CGRectMake(0, 0, indentationWidth, rect.height)
    }
    
    // MARK: - Touches
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if (accessory.text == String.fontAwesomeIconWithName("fa-angle-right")) {
            
            accessory.text = String.fontAwesomeIconWithName("fa-angle-down")
        }
        else {
            accessory.text = String.fontAwesomeIconWithName("fa-angle-right")
        }
        delegate.expandOrContractSection(exploreItem.rawValue)
    }
}
