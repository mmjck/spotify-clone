//
//  SearchResultsViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit
struct SearchSection {
    let title: String
    let results: [SearchResult]
    
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}
class SearchResultsViewController: UIViewController {
    private var sections: [SearchSection] = []
    weak var delegate: SearchResultsViewControllerDelegate?
    
    
    
    private lazy var tableView: UITableView = {
        let tableView  = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultsSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultsSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    public func update(with result: [SearchResult]){
        let artists = result.filter({
            switch $0 {
            case .artists: return true
            default: return false
            }
        })
        let albums = result.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let tracks = result.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        let playlists = result.filter({
            switch $0 {
            case .playlists: return true
            default: return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "playlists", results: playlists),
            SearchSection(title: "Tracks", results: tracks)
        ]
        
        
        tableView.reloadData()
        tableView.isHidden = result.isEmpty
        
    }


}
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].results.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        let result = self.sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
            
        

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let result = self.sections[indexPath.section].results[indexPath.row]
        
        
        switch result {
        case .artists(let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: artist.name, imageUrl: URL(string: artist.images?.first?.url ?? ""))
            
            
            cell.configure(with: viewModel )
            return cell
            
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSubtitleTableViewCell .identifier, for: indexPath) as? SearchResultsSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "" ,
                imageUrl: URL(string: album.images.first?.url ?? "")
            )
            
            
            cell.configure(with: viewModel )
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSubtitleTableViewCell .identifier, for: indexPath) as? SearchResultsSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "" ,
                imageUrl: URL(string: track.album?.images.first?.url ?? "")
            )
            cell.configure(with: viewModel )
            return cell
        case .playlists(let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSubtitleTableViewCell .identifier, for: indexPath) as? SearchResultsSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name ,
                imageUrl: URL(string: playlist.images.first?.url ?? "")
            )
            cell.configure(with: viewModel )
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}


