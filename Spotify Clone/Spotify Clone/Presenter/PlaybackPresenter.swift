
//
//  PlaybackPresenter.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 08/04/23.
//

import Foundation
import AVFoundation
import UIKit


protocol PlayerDataSource: AnyObject {
    var songName: String?  { get }
    var subtitle: String?  { get }
    
    var imageUrl: URL? { get }
    
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    var playerVC: PlayerViewController?
    
    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let player = self.playerQueue, !tracks.isEmpty {
            //let item = player.currentItem
            
            //let items = player.items()
            
            //guard let index = items.firstIndex(where: { $0 == item }) else{
            //    return nil
            //}
              
            return tracks[index]
        }
        
        return nil
    }
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ){
        
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.0
        
        self.tracks = []
        self.track = track
        
        let vc = PlayerViewController()
        
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present( UINavigationController(rootViewController: vc), animated: true) { [weak self] in self?.player?.play()
        }
        
        self.playerVC = vc
    }
    
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ){
        let vc = PlayerViewController()
        self.tracks = tracks
        self.track = nil
        
        let items: [AVPlayerItem] = tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        })
        
        self.playerQueue = AVQueuePlayer(items: items)
        print(items)
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        
        viewController.present(
            UINavigationController(rootViewController: vc),
            animated: true,
            completion: nil
        )
        self.playerVC = vc
        
    }

}
extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didSlideSlided(_ value: Float) {
        player?.volume = value
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // not playulist or album
            player?.pause()
        } else if let player = playerQueue {
            player.advanceToNextItem()
            index += 1
            print(index)
            playerVC?.refreshUI()
            
        }
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }else if player.timeControlStatus == .paused {
                player.play()
            }
        }else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }

    func didTapBackwards() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0
        }
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageUrl: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
