//
//  NewReleaseCollectionViewCell.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 31/03/23.
//

import UIKit

import SDWebImage


class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"

    
    private lazy var  albumCoverImageView: UIImageView  = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo")
        
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
     
    private lazy var numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10

        let albumNameLabelSize = albumNameLabel.sizeThatFits(
            CGSize(width: contentView.width - imageSize - 10, height: contentView.height - 10))
        
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
       
        
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 10,
            width: albumNameLabelSize.width + contentView.right - 5,
            height: 20
        )
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 40,
            width: albumNameLabelSize.width + contentView.right - 5,
            height: 40
        )
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 90,
            width: albumNameLabelSize.width + contentView.right - 5,
            height: 20
        )
        
        //artistNameLabel.backgroundColor = .red
        //albumNameLabel.backgroundColor = .blue
        //numberOfTracksLabel.backgroundColor = .green
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
       
       
    }
    
    
    
    func configure(with viewModel: NewReleasesCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
