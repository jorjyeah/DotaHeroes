//
//  HeroImageCell.swift
//  DotaHeroes
//
//  Created by jorjyeah  on 12/06/22.
//

import UIKit

class HeroImageCell: UITableViewCell {
    
    lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle = .value1, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupViews(){
        backgroundColor = .white
        self.addSubview(heroImageView)
    }
    
    private func setupLayouts(){
        debugPrint(self.frame.width)
        debugPrint(self.frame.height)
        NSLayoutConstraint.activate([
            heroImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            heroImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            heroImageView.topAnchor.constraint(equalTo: self.topAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: self.frame.width * (144/256)),
            heroImageView.heightAnchor.constraint(equalTo: self.heightAnchor),

        ])
    }
}

extension HeroImageCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
