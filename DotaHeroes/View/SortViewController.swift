//
//  SortViewController.swift
//  DotaHeroes
//
//  Created by jorjyeah  on 12/06/22.
//

import UIKit

protocol SelectSortDelegate : AnyObject {
    func applyTapped(index: Int)
}

class SortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortParam.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .value1, reuseIdentifier: "cell")
                }
            return cell
        }()
        
        cell.textLabel?.text = sortParam[indexPath.row]
        
        return cell
    }
    
    var selectedIndex = 0
    
    var sortParam: [String] = ["Base Attack (Lower Limit)", "Base Health", "Base Mana", "Base Speed"]
    var sortDelegate: SelectSortDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        setupViews()
        setupLayouts()
    }
    
    private func setupViews(){
        self.view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(applyButton))

    }
    
    @objc func applyButton(){
        sortDelegate?.applyTapped(index: selectedIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupLayouts(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.view.safeAreaInsets.top),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),

        ])
    }
}
