//
//  PlayerControllsView.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 08/04/23.
//

import Foundation
import UIKit
protocol PlayerControlsViewDelegate: AnyObject {
    func playControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    weak var delegate: PlayerControlsViewDelegate?
    private lazy var volumesSlider: UISlider = {
        let slider = UISlider()
        
        slider.value = 0.5
        return slider
    } ()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
   }()
    
    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
   }()
    
    
    private lazy var backButton: UIButton = {
        
        let image = UIImage(systemName: "backward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular ))
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var playPauseButton: UIButton = {
        
        let image = UIImage(systemName: "pause",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular ))
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    private lazy var forwardButton: UIButton = {
        
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
                
        let button = UIButton()
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
                
        let button = UIButton()
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  .clear
        
        addSubview(nameLabel)

        addSubview(subtitle)
        
        addSubview(volumesSlider)

       
        addSubview(playPauseButton)
        addSubview(backButton)
        
        
        addSubview(forwardButton)
        addSubview(nextButton)
        
        
        backButton.addTarget(self, action: #selector(didTapback), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        

        clipsToBounds = true
    }
    
    
    @objc private func didTapback(){
        delegate?.playControlsViewDidTapBackwardsButton(self)
    }
    
    @objc private func didTapNext(){
        delegate?.playControlsViewDidTapForwardButton(self)
    }
    
    @objc private func didTapPlayPause(){
        delegate?.playControlsViewDidTapPlayPauseButton(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitle.frame = CGRect(x: 0, y: nameLabel.bottom + 20 , width: width, height: 50)
        
        volumesSlider.frame = CGRect(x: 1, y: subtitle.bottom + 20 , width: width - 20, height: 44)
        
        let buttonSize : CGFloat = 60
        
        
        playPauseButton.frame = CGRect(x: (width - buttonSize) / 2, y: volumesSlider.bottom + 30, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left - 80 - buttonSize, y: playPauseButton.top , width: buttonSize , height: buttonSize)
        nextButton.frame = CGRect(x: playPauseButton.right + 80, y: playPauseButton.top , width: buttonSize , height: buttonSize)

        
    }
    
}
