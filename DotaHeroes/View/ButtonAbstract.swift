//
//  FilterButton.swift
//  DotaHeroes
//
//  Created by jorjyeah  on 08/06/22.
//

import Foundation
import UIKit

public
protocol CustomizeButton {
    
    /// Override the default color. `nil` value will be ignored.
    /// - Parameters:
    ///   - primary: This will be used when `normal` state.
    ///   - secondary: This will be used when `onPress` state.
    ///   - tertiary: This will be used when `disabled` state.
    func setDefaultColor(primary: UIColor?, secondary: UIColor?, tertiary: UIColor?)
}

@IBDesignable public
class ButtonAbstract: UIButton {    
    // MARK: - Properties
    var isPressed: Bool = false {
        didSet {
            responseHandling()
        }
    }
    
    private var selectedPrimaryColor: UIColor = UIColor.black
    private var selectedSecondaryColor: UIColor = UIColor.white
    
    /// Normal Color
    var primaryColor: UIColor { return selectedPrimaryColor }
    
    /// Pressed Color
    var secondaryColor: UIColor { return selectedSecondaryColor }
    
    // MARK: - Default Functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isPressed = !isPressed
    }

    
    public func responseHandling() {}
    
    // MARK: - Private Functions
    private func setupViews() {
        clipsToBounds = true
    }
    
}

extension ButtonAbstract: CustomizeButton {
    public func setDefaultColor(primary: UIColor? = nil, secondary: UIColor? = nil, tertiary: UIColor? = nil) {
        if let unwrappedPrimary: UIColor = primary {
            self.selectedPrimaryColor = unwrappedPrimary
        }
        
        if let unwrappedSecondary: UIColor = secondary {
            self.selectedSecondaryColor = unwrappedSecondary
        }
    }
}
