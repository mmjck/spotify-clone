//
//  ViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit

enum BrowserSectino {
    case newReleases
    case featuredPlaylists
    case RecommendedTracks
}

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout:  UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSection(section: sectionIndex)}
    )
    
    private lazy var spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        
        return spinner
    }()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
        
        view.addSubview(spinner)
        configureCollectionView()
//        fetchData()
        
    }
    
    private func configureCollectionView(){
        self.view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private static func createSection(section: Int) -> NSCollectionLayoutSection{
        switch section {
        case 0:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
                ),
              repeatingSubitem: item, count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(360)
                ),
              repeatingSubitem: verticalGroup, count: 1
            )
            
            // Section
            let _section = NSCollectionLayoutSection(group: horizontalGroup)
            _section.orthogonalScrollingBehavior = .groupPaging
            return _section
        case 1:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(150)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
          
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(150),
                heightDimension: .absolute(300)
                ),
              repeatingSubitem: item, count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(150),
                heightDimension: .absolute(300)
                ),
              repeatingSubitem: verticalGroup, count: 1
            )
                
            
            // Section
            let _section = NSCollectionLayoutSection(group: horizontalGroup)
            _section.orthogonalScrollingBehavior = .groupPaging
            return _section
        case 2:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // Group
       
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
                ),
              repeatingSubitem: item, count: 1
            )

            let _section = NSCollectionLayoutSection(group: group)
            return _section
            
        default:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120)
                ),
              repeatingSubitem: item, count: 1
            )
         
            // Section
            let _section = NSCollectionLayoutSection(group: group)
            return _section
        }
        
    }
    
    private func fetchData(){
        // Featured playlists
        
        APICaller.shared.getRecommendedGenres{ result in
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                    
                }
                
                APICaller.shared.getRecommendations(genres: seeds){
                    result in
                    switch result {
                    case .success(let model):
                        print("aqui error", model)
                    case .failure(let error):
                        print("aqui error", error)
                    }
                }
                
                break
            case .failure(let error):
                print("aqui error", error)
                break
            }
            
            
        }
    }
    
}

extension HomeViewController {
    @objc func didTapSettings(){
        let settingsViewController = SettingsViewController()
        
        self.navigationController?.pushViewController(settingsViewController, animated: true)
        
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0{
            cell.backgroundColor = .systemGreen
        }
        
        
        if indexPath.section == 1 {
            cell.backgroundColor = .systemPink
        }
        
        if indexPath.section == 2{
            cell.backgroundColor = .systemBlue
        }
       return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
}
