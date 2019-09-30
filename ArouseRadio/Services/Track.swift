//
//  Track.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/19/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class Music {
    var tracks: [Track]?
    
    init(json from: [String : Any]) {
        self.tracks = [Track]()
        if let recentData = from["recenttracks"] as? [String : Any] {
            if let tracks = recentData["track"] as? [[String : Any]] {
                tracks.forEach() { track in
                    self.tracks?.append(Track(track: track))
                }
            }
        }
    }
}


class Track: Equatable {
    
    var artist: Artist?
    var album: Album?
    var image: Image?
    var name: String?
    var albumArt: UIImage?
    var isNowPlaying: Bool?
    
    init(track from: [String : Any]) {
        var artist = Artist()
        var album = Album()
        var image = Image()
        
        
        self.name = from["name"] as? String
        
        if let attr = from["@attr"] as? [String : Any] {
            if let nowPlaying = attr["nowplaying"] as? String {
                self.isNowPlaying = Bool(nowPlaying)
            }
        }
        
        if let artistData = from["artist"] as? [String : Any] {
            artist.text = artistData["#text"] as? String
        }
        
        if let albumData = from["album"] as? [String : Any] {
            album.text = albumData["#text"] as? String
        }
        
        if let imageData = from["image"] as? [[String : Any]] {
            image.text = imageData[3]["#text"] as? String
            //Ideally this should not be here
            
//            if let validUrl = URL(string: image.text ?? "") {
//                let image = UIImage(url: validUrl)
//            }
            
            _ = NetworkService.getImage(url: URL(string: image.text ?? "")).subscribe() { (event: Event<UIImage>) in
                if let image = event.element {
                    self.albumArt = image
                }
            }
        }
        
        self.album = album
        self.artist = artist
        self.image = image
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.artist?.text == rhs.artist?.text && lhs.name == rhs.name
    }
}

struct Artist {
    var text: String?
}

struct Album {
    var text: String?
}

struct Image {
    var text: String?
}
