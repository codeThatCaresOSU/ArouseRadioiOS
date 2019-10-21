//
//  JSONService.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/19/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation
import RxSwift

class JSONService {
    private var networkService: NetworkService?
    private var decoder: JSONDecoder?
    
    init() {
        self.networkService = NetworkService()
        self.decoder = JSONDecoder()
    }
    
    public static func serialize(data: Data) -> [String : Any]? {
        var json: [String : Any]?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
        } catch {
          print("Error parsing json")
        }
        
        return json
    }
}
