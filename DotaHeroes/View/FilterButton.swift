//
//  FilterButton.swift
//  DotaHeroes
//
//  Created by jorjyeah  on 08/06/22.
//

import UIKit

protocol FilterButtonDelegate: AnyObject {
    func getStatus(isPressed: Bool, tag: Int)
}


class FilterButton: ButtonAbstract {
        
    var textColorPressed: UIColor {
        return isPressed ? secondaryColor.withAlphaComponent(0.8) : secondaryColor
    }
    
    var delegate: FilterButtonDelegate?
    
    // MARK: - Override Functions
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override public func responseHandling() {
        self.backgroundColor = isPressed ? secondaryColor : primaryColor
        self.setTitleColor(isPressed ? primaryColor : secondaryColor
                           , for: .normal)
        delegate?.getStatus(isPressed: isPressed, tag: self.tag)
    }
    
    // MARK: - Private Functions
    private func setupViews() {
        self.backgroundColor = primaryColor
        contentEdgeInsets = UIEdgeInsets(top: 2, left: 16, bottom: 2, right: 16)
        layer.cornerRadius = 8
    }
}
