//
//  AlbumTrackCollectionViewCell.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 03/04/23.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"

    
    
    private lazy var playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
     
  private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground

        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
      
        
        playlistNameLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width,
            height: contentView.height / 2
        )
        
        artistNameLabel.frame = CGRect(
            x: 10,
            y: contentView.height / 2,
            width: contentView.width,
            height: contentView.height / 2
        )
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    public func configure(with viewModel: AlbumCollectionViewCellViewModel){
        playlistNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }

}
