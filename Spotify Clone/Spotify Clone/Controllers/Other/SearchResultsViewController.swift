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
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath )
        let result = self.sections[indexPath.section].results[indexPath.row]
        
        
        switch result {
        case .artists(let model):
            cell.textLabel?.text = "\(model.name)"
        case .album(let model):
            cell.textLabel?.text = "\(model.name)"
        case .track(let model):
            cell.textLabel?.text = "\(model.name)"
        case .playlists(let model):
            cell.textLabel?.text = "\(model.name)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}


