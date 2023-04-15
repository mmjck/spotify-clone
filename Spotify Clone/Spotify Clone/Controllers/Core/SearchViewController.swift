//
//  SearchViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit

class SearchViewController: UIViewController {
    private lazy var searchController: UISearchController = {
        
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albumns"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    
    private lazy var collectionView: UICollectionView  = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {_, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(180)
                ),
                repeatingSubitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 0,
                bottom: 10,
                trailing: 0
            )
            
            return NSCollectionLayoutSection(group: group)
        })
    )
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        
        self.view.addSubview(collectionView)
        
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        fetchData()
    }
    
    
    private var categories = [Category]()
    
    func fetchData(){
        APICaller.shared.getCategory {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.categories = model
                    self?.collectionView.reloadData()
                    
                    
                    break
                case  .failure(let error):
                    print(error)
                    break
                    
                }
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.frame = self.view.bounds
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell
        else {
            return UICollectionViewCell()
            
        }
        
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(name: category.name, artworkURL: URL(string: category.icons.first?.url ?? "")))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}



extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       
        
        
        //        APICaller.shared.
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let resultsController = self.searchController.searchResultsController as? SearchResultsViewController, let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.delegate = self
        APICaller.shared.search(with: query){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    resultsController.update(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}


extension SearchViewController: SearchResultsViewControllerDelegate{
    func didTapResult(_ result: SearchResult) {
    
        switch result {
        case .artists(let model):
            break
        case .album(let model):
            let vc = AlbumViewController(album: model)
            navigationController?.pushViewController(vc, animated: true)
        case .track(let model):
            PlaybackPresenter.shared .startPlayback(from: self, track: model)
            break
        case .playlists(let model):
            let vc = PlaylistViewController(playlist: model)
            navigationController?.pushViewController(vc, animated: true)           
        }
        
    
    }
}
