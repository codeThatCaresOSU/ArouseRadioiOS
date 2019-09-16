//
//  Global.swift
//  ArouseRadio
//
//  Created by Jared Williams on 9/16/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        let r = CGFloat.random(in: 0..<255)
        let g = CGFloat.random(in: 0..<255)
        let b = CGFloat.random(in: 0..<255)
        
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 0.9)
    }
}
