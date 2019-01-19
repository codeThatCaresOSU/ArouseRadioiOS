//
//  RadioViewModel.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/15/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation

class RadioViewModel {
    private var audioService: AudioService?
    private var radioController: RadioController?
    private var networkService: NetworkService?
    private var siteState: SiteState?
    private var arouseUrl = URL(string: "http://arouseosu.com:8800/stream")
    
    init(delegate: RadioController) {
        self.audioService = AudioService()
        self.networkService = NetworkService()
        self.radioController = delegate
        if let url = self.arouseUrl {
            self.networkService?.notifySiteState(url: url, completion: self.isSiteStreaming)
        }
    }
    
    public func playButtonPressed() {
        self.audioService?.playStream()
        self.radioController?.updateUI()
    }
    public func stopButtonPressed() {
        self.audioService?.pauseStream()
        self.radioController?.updateUI()
    }
    public func liveButtonPressed() { }
    
    public var liveLabel: String {
        return self.siteState == SiteState.Up ? "Live Now" : "Not Live"
    }
    
    public var playPauseJsonString: String {
        return self.audioService == nil ? "pause_to_play" : (self.audioService!.isStreaming ? "play_to_pause" : "pause_to_play")
    }
    
    public var isPlaying: Bool {
        return self.audioService == nil ? false : (self.audioService!.isStreaming)
    }
    
    private func isSiteStreaming(siteState: SiteState) {
        self.siteState = siteState
    }

}
