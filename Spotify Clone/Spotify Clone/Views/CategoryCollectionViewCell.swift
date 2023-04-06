//
//  GenreCollectionViewCell.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 03/04/23.
//

import UIKit
import SDWebImage
class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GenreCollectionViewCell"
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBackground,
        .systemBlue,
        .systemGreen,
        .systemGray,
        .systemRed,
        .systemYellow,
        .systemBrown,
        .darkGray
    ]
    
    
    private lazy var imageView: UIImageView  = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular))
        
        
        return imageView
    }()
    
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        addSubview(imageView)
        addSubview(label)
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        label.frame = CGRect(x: 10, y: contentView.height / 2, width: contentView.width - 20, height: contentView.height  / 2)
        imageView.frame = CGRect(x: contentView.width / 2, y: 10, width: contentView.width / 2, height: contentView.height / 2 )
    }
    
    override func prepareForReuse() {
        label.text = nil
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular))
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel){
        label.text = viewModel.name
        let color = colors.randomElement()
        label.backgroundColor = color
        contentView.backgroundColor = color
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
