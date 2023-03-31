//
//  ProfileViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit
import SDWebImage
class ProfileViewController: UIViewController {
    
    private var models = [String]()
    
    private lazy var tableView: UITableView  = {
        
        let tableView = UITableView(frame: .zero, style: .grouped )
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.color = .red
        view.isHidden = false
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureScreen()
        
        self.view.addSubview(tableView)
        self.view.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
          ])
       
        fetchProfile()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.backgroundColor = .systemBackground
       
    }
    
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }
    
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { [weak self]
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print("called")
                    self?.updateUI(with: model)
                    break
                case .failure(let error):
                    print("Profile error \(error.localizedDescription)")
                    self?.failedGetProfile()
                    
                }
            }
            
        }
    }
    
    
    private func configureScreen(){
        self.view.backgroundColor = .systemBackground
        self.title = "Profile"
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func updateUI(with model: UserProfile){
        self.tableView.isHidden = false
        self.indicatorView.isHidden = true
        
        
        self.models.append("Full Name \(model.display_name)")
        self.models.append("Email Address \(model.email)")
        self.models.append("User Id \(model.id)")
        self.models.append("Plan \(model.product)")
        
        
        self.createTableHeader(with: model.images.first?.url)
        
        self.tableView.reloadData()
    }
    
    private func createTableHeader(with string: String?){
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.width / 1.5))
        let imageSize: CGFloat = headerView.height / 2
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        
        tableView.tableHeaderView = headerView
    }
    
    private func failedGetProfile(){
        self.indicatorView.isHidden = true
        self.view.addSubview(errorLabel)
        errorLabel.center  = self.view.center
        
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

