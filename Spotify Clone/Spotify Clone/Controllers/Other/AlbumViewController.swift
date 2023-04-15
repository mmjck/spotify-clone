//
//  AlbumViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 02/04/23.
//

import UIKit

class AlbumViewController: UIViewController {
    private let album: Album
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout:
            UICollectionViewCompositionalLayout(sectionProvider: {
                _, _ -> NSCollectionLayoutSection? in
                // Item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(80)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 1,
                    leading: 1,
                    bottom: 1,
                    trailing: 1
                )
                
                
                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(80)),
                    repeatingSubitem: item, count: 1
                )
                
                let _section = NSCollectionLayoutSection(group: group)
                _section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(1)),
                        elementKind:UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                    
                ]
                return _section
                
            })
    )
    
    
    required init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = self.album.name
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        
        view.addSubview(collectionView)
        
        collectionView.register(
            AlbumTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier
        )
        
        
        collectionView.register( PlaylistHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        fetchData()
    }
    
    
    
    
    private var viewModels: [AlbumCollectionViewCellViewModel] = [AlbumCollectionViewCellViewModel]()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private var tracks = [AudioTrack]()
    
    public func fetchData(){
        APICaller.shared.getAlbumDetails(for: album) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumCollectionViewCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? ""
                        )
                     })
                    self?.collectionView.reloadData()
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .red
        cell.configure(with: viewModels[indexPath.row])
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        var track = tracks[indexPath.row]
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                         at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath) as? PlaylistHeaderCollectionReusableView,
                kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerVM = PlaylistHeaderViewModel(
            name: album.name,
            owner: album.artists.first?.name,
            description: "Release date: \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? "")
        )
        
        
        header.configure(with: headerVM)
        
        return header
    }
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap({
            var _track = $0
            _track.album = self.album
            return _track
        })
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
}


