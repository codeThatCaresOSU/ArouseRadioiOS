//
//  NetworkService.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/19/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation
import RxSwift
import UIKit


class NetworkService {
    
    public static func getEvery(seconds timeInterval: TimeInterval, url: URL?) -> PublishSubject<Data> {
        let observer = PublishSubject<Data>()
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            print("Timer fired")
            if let unwrappedUrl = url {
                _ = NetworkService.get(url: unwrappedUrl).subscribe() { (event: Event<Data?>?) in
                    if let unwrappedEvent = event, let unwrappedElement = unwrappedEvent.element, let unwrappedData = unwrappedElement {
                        observer.onNext(unwrappedData)
                    }
                }
            }
        }
        
        timer.fire()
        
        return observer
    }
    
    public static func getImage(url: URL?) -> PublishSubject<UIImage> {
        let observer = PublishSubject<UIImage>()
        
        if let unwrappedUrl = url {
             NetworkService.get(url: unwrappedUrl).subscribe() { (event: Event<Data?>?) in
                if let unwrappedEvent = event, let unwrappedElement = unwrappedEvent.element, let unwrappedData = unwrappedElement {
                    if let image = UIImage(data: unwrappedData) {
                        observer.onNext(image)
                    }
                }
            }
        }
        
        return observer
    }
    
    private static func get(url: URL) -> PublishSubject<Data?> {
        let dataObserver = PublishSubject<Data?>()
        
        URLSession.shared.dataTask(with: url) { (data: Data?, response, error) in
            if error == nil, data != nil {
                dataObserver.onNext(data)
            }
        }.resume()
        
        return dataObserver
    }
}

