//
//  PlayerViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit

class PlayerViewController: UIViewController {
    private let controlsView =  PlayerControlsView()
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        return imageView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(controlsView)

        
        controlsView.delegate = self
        configureBarButon()
        
    }
    
    
    private func configureBarButon(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClosed)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapClosed)
        )
    }
    
    @objc private func didTapClosed(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        
        controlsView.frame = CGRect(x: 10, y: imageView.bottom + 10, width: view.width - 20, height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 10)
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        return
    }
    
    func playControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        return
    }
    
    func playControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        return
    }
    
    }
