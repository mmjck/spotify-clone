//
//  SearchResultDefaultTableViewCell.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 07/04/23.
//

import UIKit
import SDWebImage


class SearchResultsSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultsSubtitleTableViewCell"
    
    
    
    
    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        // label.textAlignment = .center
        // label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        // label.textAlignment = .center
        // label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var iconImageView: UIImageView  = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(subtitle)
        contentView.addSubview(label)

        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let imageSize: CGFloat = contentView.height - 10
        
        iconImageView.frame = CGRect(x: 10,
                                     y: 0,
                                     width: imageSize,
                                     height: imageSize
        )
        
        iconImageView.layer.cornerRadius = imageSize / 2
        iconImageView.layer.masksToBounds = true
        
        let labelHeight: CGFloat = contentView.height / 2
        
        label.frame = CGRect(x: iconImageView.right + 10,
                             y: 0,
                             width: contentView.width ,
                             height: labelHeight
        )
        
        subtitle.frame = CGRect(
            x: iconImageView.right + 10,
            y: label.bottom,
            width: contentView.width,
            height: labelHeight
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
        subtitle.text = nil

    }
    
    func configure(with viewModel: SearchResultsSubtitleTableViewCellViewModel){
        print(viewModel)
        label.text = viewModel.title
        subtitle.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }

}
