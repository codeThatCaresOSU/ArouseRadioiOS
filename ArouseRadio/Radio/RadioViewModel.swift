//
//  RadioViewModel.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/15/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation
import RxSwift

class RadioViewModel {
    
    public var updateUISubject: BehaviorSubject<Any?>?
    private var audioService: AudioService?
    private var jsonService: JSONService?
    private var liveState: Bool = true
    private var arouseUrl = URL(string: "http://arouseosu.com:8800/stream")
    private var apiURL = URL(string: "https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=arouseosu&api_key=2e7355577ebe34457b2bc801bd9f23ff&format=json")
    private var timer: Timer?
    public var isPlaying: Bool = false
    public var stopButtonLabel: String {
        return self.isPlaying ? "Stop" : "Resume Live Broadcast"
    }
    public var music: Music?
    public var nowPlayingAlbumArt: UIImage? {
        get {
            return self.music?.tracks?[0].albumArt ?? UIImage()
        }
    }
    public var nowPlayingSong: String? {
        return self.music?.tracks?[0].name
    }
    
    public var nowPlayingArtist: String? {
        return self.music?.tracks?[0].artist?.text
    }
    
    private var radioState: RadioState = RadioState(albumUrl: nil, liveNowLabel: "Press To Go Live", musicLabel: "", songLabel: "", albumLabel: "", currentlyPlaying: false, shouldChangePlayButtonState: false)
    
    init(audioService: AudioService, onNowPlayingUpdate: PublishSubject<Music>) {
        self.audioService = audioService
        self.updateUISubject = BehaviorSubject<Any?>(value: nil)
        
        onNowPlayingUpdate.subscribe() { (event: Event<Music>) in
            if let unwrappedMusic = event.element {
                
                if let albumArt = unwrappedMusic.tracks?[0].albumArt {
                    self.music = unwrappedMusic
                    self.updateUISubject?.onNext(nil)
                } else {
                    if let existingAlbumArt = self.music?.tracks?[0].albumArt {
                        self.music = unwrappedMusic
                        self.music?.tracks?[0].albumArt = existingAlbumArt
                        self.updateUISubject?.onNext(nil)
                    } else {
                        self.music = unwrappedMusic
                        self.updateUISubject?.onNext(nil)
                    }
                }
            }
        }
    }
    
    public func playButtonPressed() {
        self.isPlaying = !self.isPlaying
        
        if self.isPlaying {
            self.audioService?.playStream()
        } else {
            self.audioService?.pauseStream()
            self.liveState = false
        }
        
        self.radioState.shouldChangePlayButtonState = true
        self.updateUISubject?.onNext(nil)
    }
    
    public func stopButtonPressed() {
        self.audioService?.pauseStream()
        self.liveState = false
        self.radioState.shouldChangePlayButtonState = true
        self.updateUISubject?.onNext(nil)
        self.isPlaying = !self.isPlaying
        
    }
    
    public func liveLabelPressed() {
        if !self.liveState {
            self.liveState = true
            self.audioService = AudioService()
            self.audioService?.playStream()
            self.isPlaying = true
            self.radioState.shouldChangePlayButtonState = true
            self.updateUISubject?.onNext(nil)
        }
    }
    
    public var liveLabel: String {
        return self.liveState ? "Live Now" : "Press To Go Live"
    }
    
    public var smokeUrl: URL? {
        let url = Bundle.main.path(forResource: "smoke", ofType: "mp4")
        if let video = url {
            return URL(fileURLWithPath: video)
        }
        
        return URL(string: "")
    }
    
    public var playPauseJsonString: String {
        return self.isPlaying ? "pause_to_play" : "play_to_pause"
    }
}
