//
//  LiveLabel.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/19/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class LiveLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
        
   }
    
    func setupConstraints() {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
