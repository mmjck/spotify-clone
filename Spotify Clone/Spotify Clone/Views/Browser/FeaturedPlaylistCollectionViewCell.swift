//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 31/03/23.
//

import UIKit


class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    
    private lazy var playlistCoverImageView: UIImageView  = {
       let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    private lazy var playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
     
  private lazy var createNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(createNameLabel)
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 44,
            width: contentView.width - 6,
            height: 40
        )
        
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 88,
            width: contentView.width - 6,
            height: 40
        )
        
        let imageSize = contentView.height - 90
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width - imageSize) / 2,
            y: 3,
            width: imageSize + 4,
            height: imageSize + 4)
        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playlistCoverImageView.image = nil
        playlistNameLabel.text = nil
        createNameLabel.text = nil
    }
    
    public func configure(with viewModel:FeaturedPlaylistCellViewModel){
        playlistCoverImageView.sd_setImage(with: viewModel.artworkUrl, completed: nil)

        playlistNameLabel.text = viewModel.name
        createNameLabel.text = viewModel.creatorName
    }
    
    
}
