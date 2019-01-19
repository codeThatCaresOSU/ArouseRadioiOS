//
//  AudioService.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/15/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioService {
    
    private var audioPlayer: AVPlayer?
    private var audioItem: AVPlayerItem?
    private let streamingUrl = "http://arouseosu.com:8800/stream"
    private var streamingState: StreamState = .Stopped
    
    init() {
        self.setupAudioTools()
    }
    
    public var isStreaming: Bool {
        return self.streamingState == .Streaming
    }
    
    public func playStream() {
        if self.streamingState == .Stopped, self.audioItem != nil, self.audioPlayer != nil {
            self.audioPlayer?.play()
            self.streamingState = .Streaming
            self.setupAduioSession()
            self.setupNowPlaying()
        }
    }
    
    public func pauseStream() {
        if self.streamingState == .Streaming, self.audioItem != nil, self.audioPlayer != nil {
            self.audioPlayer?.pause()
            self.streamingState = .Stopped
            self.tearDownNowPlaying()
        }
    }
    
    public func fastForwardToLiveStream() {
        self.setupAudioTools()
    }
    
    
    private func setupAudioTools() {
        if let url = URL(string: self.streamingUrl) {
            self.audioItem = AVPlayerItem(url: url)
            self.audioPlayer = AVPlayer(playerItem: self.audioItem)
        }
    }
    
    private func setupAduioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay] )
        } catch { /** Handle this **/ }
    }
    
    private func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Arouse OSU Radio"
        if let album = UIImage(named: "arouseLogo") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: album.size) { size in
                return album
            }
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func tearDownNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    
    enum StreamState {
        case Streaming
        case Stopped
    }
}

