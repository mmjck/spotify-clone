//
//  SettingsViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var sections: [Section] = [Section]()
    
    private lazy var tableView: UITableView  = {
        let tableView = UITableView(frame: .zero, style: .grouped )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.view.backgroundColor = .systemBackground
        
        configureModels()
        self.view.addSubview(tableView)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    private func configureModels(){
        sections.append(Section(title: "Profile", option: [
            Option(title: "View Your Profile", handle:  { [weak self] in
                DispatchQueue.main.async {
                    self?.viewProfile()
                }
            })
        ]))
        
        
        sections.append(Section(title: "Account", option: [
            Option(title: "Sign Out", handle:  { [weak self] in
                DispatchQueue.main.async {
                    self?.signOut()
                }
            })
        ]))
        
    }
    
    private func signOut(){
        
    }
    
    
    private func viewProfile(){
        let profileViewController = ProfileViewController()
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    
    
}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].option[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let model = sections[indexPath.section].option[indexPath.row]
        model.handle()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        
        return model.title
    }
    
}
