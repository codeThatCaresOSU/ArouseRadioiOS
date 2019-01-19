//
//  LiveLabel.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/19/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class LiveLabel: UILabel {
    
    private lazy var liveIcon: LOTAnimationView = {
        let view = LOTAnimationView(name: "circle_red_button")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.liveIcon)
        self.setupConstraints()
        
        self.liveIcon.play()
        self.liveIcon.loopAnimation = true
    }
    
    func setupConstraints() {
        self.liveIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        self.liveIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.liveIcon.widthAnchor.constraint(equalToConstant: 35).isActive = true
        self.liveIcon.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
