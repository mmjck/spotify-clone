//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 02/04/23.
//

import UIKit
import SDWebImage


protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "PlaylistHeaderCollectionReusableView"
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setImage(UIImage(systemName: "play.fill") , for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    } ()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "photo")
        
        return imageView
    } ()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        addSubview(playButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageViewSize: CGFloat = height / 1.5
        imageView.frame = CGRect(
            x: (width - imageViewSize) / 2,
            y: 20,
            width: imageViewSize,
            height: imageViewSize
        )
        
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width - 20, height: 40)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: 250, height: 30)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: width - 20, height: 40)

        playButton.frame = CGRect(x: width - 100, y: height - 100, width: 50, height: 50)

        
        
        playButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    func configure (with viewModel: PlaylistHeaderViewModel){
        self.descriptionLabel.text = viewModel.description
        self.ownerLabel.text = viewModel.owner
        self.nameLabel.text = viewModel.name
        self.imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}


extension PlaylistHeaderCollectionReusableView {
    @objc private func didTapPlayAll(){
        self.delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
}
