//
//  HeroesViewController.swift
//  DotaHeroes
//
//  Created by jorjyeah  on 07/06/22.
//

import UIKit

class HeroesViewController: UIViewController, FilterButtonDelegate, SelectSortDelegate {
    func applyTapped(index: Int) {
        heroesFilter = heroesFilter.sorted{
            if index == 1 {
                return $0.baseAttackMin > $1.baseAttackMin
            } else if index == 2 {
                return $0.baseHealth > $1.baseHealth
            } else if index == 3 {
                return $0.baseMana > $1.baseMana
            } else if index == 4 {
                return $0.moveSpeed > $1.moveSpeed
            } else {
                return $0.heroID > $1.heroID
            }
        }
        
        heroesDisplay.reloadData()
    }

    func getStatus(isPressed: Bool, tag: Int) {
        debugPrint("\(tag) \(isPressed)")
        if tag != 999 {
            roles.updateValue(isPressed, forKey: roles[tag].key)
        } else {
            if isPressed{
                roles.forEach { (key: DotaRole, value: Bool) in
                    roles.updateValue(false, forKey: key)
                }
                
                filterButtons.forEach { filterButton in
                    filterButton.isPressed = false
                }
            }
        }
        
        roles.forEach { (key: DotaRole, value: Bool) in
            if value {
                rolesSelected.append(key)
            } else {
                rolesSelected.removeAll { dotaRole in
                    dotaRole == key
                }
            }
        }
        
        if rolesSelected.isEmpty {
            heroesFilter = heroes
        } else {
            heroesFilter = heroes.filter { dotaHero in
                dotaHero.roles.contains { role in
                    rolesSelected.contains { roleSelected in
                        roleSelected == role
                    }
                }
            }
        }
        
        
        heroesDisplay.reloadData()
    }
    
    var roles = DotaRole
        .allCases
        .enumerated()
        .reduce(into: [:]) { $0[$1.element] = false }

    
    var rolesSelected: [DotaRole] = []
    var isAllButtonSelected: Bool = false
    var heroes: [DotaHero] = []
    var heroesFilter: [DotaHero] = []
    var heroViewModel = DotaHeroViewModel()
    
    private lazy var horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = thinMargin
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var heroesDisplay: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    
        return collectionView
    }()
    
    private lazy var allButton: FilterButton = {
        let allButton = FilterButton()
        allButton.tag = 999
        allButton.isPressed = false
        allButton.setTitle("All", for: .normal)
        allButton.translatesAutoresizingMaskIntoConstraints = false
        allButton.delegate = self
        return allButton
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "line.3.horizontal.decrease.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sortTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterButtons: [FilterButton] = []
    
    @objc func sortTapped(){
        let vc = SortViewController()
        vc.sortDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
    }

    private func setupViews(){
        self.title = "Heroes"
        self.view.addSubview(horizontalScrollView)
        self.view.addSubview(heroesDisplay)
        self.view.addSubview(emptyView)
        emptyView.addSubview(sortButton)
        horizontalScrollView.addSubview(horizontalStackView)
        
        for index in 0...roles.count-1 {
            let filterButton = FilterButton()
            filterButton.tag = index
            filterButton.setTitle(roles[index].key.rawValue, for: .normal)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.delegate = self
            filterButtons.append(filterButton)
            horizontalStackView.addArrangedSubview(filterButton)
        }
        
        
        horizontalStackView.insertArrangedSubview(allButton, at: 0)
        
        
        
        heroViewModel.fetchData { heroes in
            debugPrint(heroes)
            self.heroes = heroes
            self.heroesFilter = self.heroes
            DispatchQueue.main.async {
                self.heroesDisplay.reloadData()
            }
        }
    }
    
    private func setupLayouts(){
        NSLayoutConstraint.activate([
            horizontalScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            horizontalScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -thinMargin),
            horizontalScrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
            
            heroesDisplay.topAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor, constant: thinMargin),
            heroesDisplay.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            heroesDisplay.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            heroesDisplay.bottomAnchor.constraint(equalTo: emptyView.topAnchor),
            
            emptyView.topAnchor.constraint(equalTo: heroesDisplay.bottomAnchor, constant: thinMargin),
            emptyView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 96),
            
            sortButton.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -mainMargin),
            
            horizontalStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor, constant: thinMargin),
            horizontalStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor, constant: -thinMargin),
            horizontalStackView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: horizontalScrollView.heightAnchor),
        ])
    }

}

extension HeroesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.identifier, for: indexPath) as! HeroCell
        cell.populateData(hero: heroesFilter[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(indexPath.row)
        let vc = HeroDetailViewController(heroDetail: heroesFilter[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return thinMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = (collectionView.frame.width - (lay.minimumInteritemSpacing * 2)) / 3
        let heightPerItem = collectionView.frame.height / 6

        return CGSize(width:widthPerItem, height: heightPerItem)
    }
}
