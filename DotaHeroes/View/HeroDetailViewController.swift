//
//  HeroDetailViewController.swift
//  DotaHeroes
//
//  Created by jorjyeah  on 11/06/22.
//

import Foundation
import UIKit

class HeroDetailViewController: UIViewController {
    var heroDetail: DotaHeroDetailModel?

    private lazy var heroDetailView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = mainMargin
        tableView.sectionIndexBackgroundColor = UIColor.gray
        return tableView
    }()
    
    init(heroDetail: DotaHero) {
        let heroDetailData: DotaHeroDetailModel = DotaHeroDetailModel(id: heroDetail.id,
                                                                      img: heroDetail.img,
                                                                      summary: DotaHeroDetailSummary(name: heroDetail.localizedName, icon: heroDetail.icon, attr: heroDetail.primaryAttr),
                                                                      attackType: heroDetail.attackType,
                                                                      base: DotaHeroDetailBase(health: heroDetail.baseHealth,
                                                                                               mana: heroDetail.baseMana,
                                                                                               armor: heroDetail.baseArmor,
                                                                                               attack: "\(String(heroDetail.baseAttackMin)) - \(String(heroDetail.baseAttackMax))"),
                                                                      moveSpeed: heroDetail.moveSpeed,
                                                                      roles: heroDetail.roles)
        
        self.heroDetail = heroDetailData
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.heroDetailView.reloadRows(at: [IndexPath(row: 0,section: 1)], with: .fade)
        }
    }
    
    private func setupViews(){
        self.title = heroDetail?.summary.name
        self.view.addSubview(heroDetailView)
    }
    
    private func setupLayouts(){
        NSLayoutConstraint.activate([
            heroDetailView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: thinMargin),
            heroDetailView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -thinMargin),
            heroDetailView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            heroDetailView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension HeroDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return 4
        case 5:
            return heroDetail?.roles.count ?? 0
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .value1, reuseIdentifier: "cell")
                }
            return cell
        }()
        
        guard let heroDetail = heroDetail else {
            return cell
        }
        
        switch indexPath.section {
        case 0:
            tableView.register(HeroImageCell.self, forCellReuseIdentifier: HeroImageCell.identifier)
            let cellImage = tableView.dequeueReusableCell(withIdentifier: HeroImageCell.identifier, for: indexPath) as! HeroImageCell
            cellImage.translatesAutoresizingMaskIntoConstraints = false
            cellImage.heroImageView.downloaded(from: "\(Constants.BASEURL)\(heroDetail.img)", contentMode: .scaleAspectFill)
            return cellImage
        case 1:
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            
            cell.textLabel?.text = heroDetail.summary.name
            cell.detailTextLabel?.text = heroDetail.summary.attr.rawValue.uppercased()
            guard let imageView = cell.imageView else {
                return cell
            }
            imageView.downloaded(from: "\(Constants.BASEURL)\(heroDetail.summary.icon)", contentMode: .scaleAspectFill)
            
            return cell
        case 2:
            cell.textLabel?.text = "Attack Type"
            cell.detailTextLabel?.text = heroDetail.attackType.rawValue
            break
        case 3:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "➕ Base Health"
                cell.detailTextLabel?.text = String(heroDetail.base.health)
                break
            case 1:
                cell.textLabel?.text = "🍶 Base Manna"
                cell.detailTextLabel?.text = String(heroDetail.base.mana)
                break
            case 2:
                cell.textLabel?.text = "🛡 Base Armor"
                cell.detailTextLabel?.text = String(heroDetail.base.armor)
                break
            case 3:
                cell.textLabel?.text = "⚔️ Base Health"
                cell.detailTextLabel?.text = heroDetail.base.attack
                break
            default:
                break
            }
            break
        case 4:
            cell.textLabel?.text = "🥾 Move Speed"
            cell.detailTextLabel?.text = String(heroDetail.moveSpeed)
            break
        case 5:
            cell.textLabel?.text = heroDetail.roles[indexPath.row].rawValue
            break
        default:
            break
        }
        
        return cell
    }
}
