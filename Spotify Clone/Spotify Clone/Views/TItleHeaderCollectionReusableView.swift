//
//  TItleHeaderCollectionReusableView.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 03/04/23.
//

import UIKit

class TItleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TItleHeaderCollectionReusableView"
    
    
    private lazy var label:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(label)
        
        label.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with title: String){
        label.text = title
        
    }
    
}
