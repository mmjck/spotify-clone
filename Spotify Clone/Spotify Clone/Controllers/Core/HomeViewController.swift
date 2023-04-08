//
//  ViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit

enum BrowserSectionType {
    case newReleases(viewModel: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModel: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModel: [RecommendedTrackCellViewModel])
    
    var title: String {
        switch self {
        case .newReleases:
            return "New releases Albumns"
        case .featuredPlaylists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recomended"
        }
    }
}

class HomeViewController: UIViewController {
    
    
    private var newAlbumns: [Album] = []
    private var tracks: [AudioTrack] = []
    private var playlists: [Playlist] = []
    
    
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout:  UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSection(section: sectionIndex)}
    )
    
    
    private var sections = [BrowserSectionType]()
    
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
      
        fetchData()
        
    }
    
    private func configureCollectionView(){
        self.view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.register(TItleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TItleHeaderCollectionReusableView.identifier)
        
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private static func createSection(section: Int) -> NSCollectionLayoutSection{
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)
                ),
                elementKind:UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        switch section {
        case 0:
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2)
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(120)
                ),
                repeatingSubitem: item, count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(360)
                ),
                repeatingSubitem: verticalGroup, count: 1
            )
            
            // Section
            let _section = NSCollectionLayoutSection(group: horizontalGroup)
            _section.orthogonalScrollingBehavior = .groupPaging
            _section.boundarySupplementaryItems = supplementaryViews
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
            _section.boundarySupplementaryItems = supplementaryViews
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
            
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)),
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
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(120)),
                repeatingSubitem: item, count: 1
            )
            
            // Section
            let _section = NSCollectionLayoutSection(group: group)
            return _section
        }
        
    }
    
    
    private func fetchData(){
        let group = DispatchGroup()
        var newReleasesResponse: NewReleasesResponse?
        var featuredPlaylistsResponse: FeaturedPlaylistsResponse?
        var recommendationResponse: RecommendationResponse?
        group.enter()
        group.enter()
        group.enter()
        
        // New Releases
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newReleasesResponse = model
            case .failure(let error):
                print("Error", error.localizedDescription)
            }
        }
        
        
        
        // Featured playlists
        APICaller.shared.getFlayPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlaylistsResponse = model
            case .failure(let error):
                print("Error", error.localizedDescription)
            }
        }
        
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
                
                APICaller.shared.getRecommendations(genres: seeds){recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        recommendationResponse = model
                    case .failure(let error):
                        print("Error", error.localizedDescription)
                    }
                }
                
                break
            case .failure(let error):
                print("aqui error", error)
                break
            }
        }
        
        group.notify(queue: .main)  {
            guard let albums = newReleasesResponse?.albums.items,
                  let playlists = featuredPlaylistsResponse?.playlists.items,
                  let tracks = recommendationResponse?.tracks else {
                return
            }
            
            self.configureModels(newAlbumns: albums,
                                 tracks: tracks,
                                 playlists: playlists)
        }
        
        
    }
    
    private func configureModels(
        newAlbumns: [Album],
        tracks: [AudioTrack],
        playlists: [Playlist]){
            
            self.tracks = tracks
            self.playlists = playlists
            self.newAlbumns = newAlbumns
            
            sections.append(.newReleases(viewModel: newAlbumns.compactMap({
                
                return NewReleasesCellViewModel(
                    name:  $0.name,
                    artworkURL: URL(string: $0.images.first?.url ?? ""),
                    numberOfTracks: $0.total_tracks,
                    artistName: $0.artists.first?.name ?? ""
                )
                
            })))
            sections.append(.featuredPlaylists(viewModel: playlists.compactMap({
                return FeaturedPlaylistCellViewModel(
                    name:  $0.name,
                    artworkUrl: URL(string: $0.images.first?.url ?? ""),
                    creatorName:$0.owner.display_name
                )
            })))
            
            sections.append(.recommendedTracks(viewModel: tracks.compactMap({
                return RecommendedTrackCellViewModel(
                    name:  $0.name,
                    artworkUrl: URL(string: $0.album?.images.first?.url ?? ""),
                    artistName:  $0.artists.first?.name ?? "-")
            })))
            collectionView.reloadData()
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
        let type = sections[section]
        switch type {
            
        case .newReleases(let viewModel):
            return viewModel.count
        case .featuredPlaylists(let viewModel):
            return viewModel.count
        case .recommendedTracks(let viewModel):
            return viewModel.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
            
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            cell.backgroundColor = .blue
            return cell
        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        
        switch section {
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let playlistVC = PlaylistViewController(playlist: playlist)
            navigationController?.pushViewController(playlistVC, animated: true)
            
            break
        case .recommendedTracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.startPlayback(from: self, track: track)
            break
        case .newReleases:
            let album = newAlbumns[indexPath.row]
            let albumVC = AlbumViewController(album: album)
            navigationController?.pushViewController(albumVC, animated: true)
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TItleHeaderCollectionReusableView.identifier, for: indexPath  ) as? TItleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return TItleHeaderCollectionReusableView()
        }
        
        let section = indexPath.section
        let title =  sections[section].title
        
        
        header.configure(with: title)
        return header
    }
}
