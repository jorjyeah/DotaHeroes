//
//  HeroCell.swift
//  DotaHeroes
//
//  Created by jorjyeah  on 09/06/22.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

public
class HeroCell: UICollectionViewCell {
    
    // MARK: Components
    lazy var heroLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heroImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var vStackView: UIStackView = {
        var stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = thinMargin
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        addSubview(vStackView)
        vStackView.addArrangedSubview(heroImageView)
        vStackView.addArrangedSubview(heroLabel)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupLayouts(){
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vStackView.topAnchor.constraint(equalTo: self.topAnchor),
            vStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    public func populateData(hero: DotaHero){
        heroLabel.text = hero.localizedName
        heroImageView.downloaded(from: "\(Constants.BASEURL)\(hero.img)", contentMode: .scaleAspectFill)
    }
}

extension HeroCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
