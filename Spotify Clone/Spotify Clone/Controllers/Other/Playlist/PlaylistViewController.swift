//
//  PlaylistViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private var playlist: Playlist
    private var viewModels: [RecommendedTrackCellViewModel] = [RecommendedTrackCellViewModel]()
    private var tracks: [AudioTrack] = []
    
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
                trailing: 1)
            
            
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
        
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = self.playlist.name
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(collectionView)
        
        collectionView.register(
            RecommendedTrackCollectionViewCell.self,
             forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier
        )
        
        
        collectionView.register( PlaylistHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        fetchData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShared))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    
    public func fetchData(){
        APICaller.shared.getPlaylistDetails(for: playlist) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items.compactMap({$0.track })
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(name: $0.track.name,
                                                      artworkUrl: URL(string: $0.track.album?.images.first?.url ?? ""), artistName: $0.track.artists.first?.name ?? "")
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

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .red
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Play song
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath) as? PlaylistHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerVM = PlaylistHeaderViewModel(
            name: playlist.name,
            owner: playlist.owner.display_name,
            description: playlist.description,
            artworkURL: URL(string: playlist.images.first?.url ?? ""))
        header.configure(with: headerVM)
        header.delegate = self
        return header
    }
}

extension PlaylistViewController {
    @objc func didTapShared(){
        
        guard let url = URL(string: playlist.external_urls["spotify"] as? String ?? "") else {
            return
        }
        
        
        let vc = UIActivityViewController(activityItems: [
        "Foo", url
        ], applicationActivities: [])
        
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
        
    }
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.startPlayback(from: self, tracks: tracks)

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.row
        let track = tracks[index]
        PlaybackPresenter.startPlayback(from: self, track: track)
    }
}
