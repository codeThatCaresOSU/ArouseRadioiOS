//
//  NetworkService.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/19/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation


class NetworkService {
    
    init() {}
    
    func siteIsUp(url: URL, completion: @escaping (SiteState)->()) {
        // Figure out how to do this
        completion(.Up)
    }
    
    func notifySiteState(url: URL, completion: @escaping (SiteState) -> ()) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(floatLiteral: 10.0), repeats: true) { (timer) in
            print("HI")
            self.siteIsUp(url: url) { (siteState) in
                completion(siteState)
            }
        }.fire()
    }
}

public enum SiteState {
    case Up
    case Down
}
