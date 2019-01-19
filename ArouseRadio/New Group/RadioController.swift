//
//  ViewController.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/15/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import UIKit
import Lottie

class RadioController: UIViewController {
    
    private lazy var viewModel: RadioViewModel = RadioViewModel(delegate: self)
    
    private lazy var albumArt: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "arouseLogo"))
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var playPauseAnimationView: LOTAnimationView = {
        let view = LOTAnimationView(name: self.viewModel.playPauseJsonString)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.playButtonPressed)))
        view.tintColor = .white
        return view
    }()
    
    private lazy var liveLabel: LiveLabel = {
       let label = LiveLabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.viewModel.liveLabel
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.preferredMaxLayoutWidth = 50
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
        self.setupConstraints()
        self.view.backgroundColor = .black
    }
    
    private func addSubViews() {
        self.view.addSubview(self.albumArt)
        self.view.addSubview(self.playPauseAnimationView)
        self.view.addSubview(self.liveLabel)
    }
    
    private func setupConstraints() {
        let size = self.view.frame.width * 0.75
        
        self.albumArt.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.albumArt.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.albumArt.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.albumArt.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        self.playPauseAnimationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.playPauseAnimationView.topAnchor.constraint(equalTo: self.liveLabel.bottomAnchor, constant: 16).isActive = true
        self.playPauseAnimationView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        self.playPauseAnimationView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        self.liveLabel.centerXAnchor.constraint(equalTo: self.albumArt.centerXAnchor, constant: 0).isActive = true
        self.liveLabel.topAnchor.constraint(equalTo: self.albumArt.bottomAnchor, constant: 8).isActive = true
        self.liveLabel.widthAnchor.constraint(equalTo: self.albumArt.widthAnchor).isActive = true
        self.liveLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.controlAnimations()
    }
    
    public func updateUI() {
        self.liveLabel.text = self.viewModel.liveLabel
        self.playPauseAnimationView.animation = self.viewModel.playPauseJsonString
    }
    
    private func controlAnimations() {
        self.playPauseAnimationView.animationProgress = 1.0
    }
    
    @objc private func playButtonPressed() { //Factor all of this into the ViewModel if possible
        if !self.viewModel.isPlaying {
            self.playPauseAnimationView.isUserInteractionEnabled = false
            self.viewModel.playButtonPressed()
            
            self.playPauseAnimationView.play(toProgress: 0.99) { [weak self] (true) in
                self?.playPauseAnimationView.isUserInteractionEnabled = true
            }
        } else {
            self.playPauseAnimationView.isUserInteractionEnabled = false
            self.viewModel.stopButtonPressed()
            
            
            self.playPauseAnimationView.play(toProgress: 0.99) { [weak self] (true) in
                self?.playPauseAnimationView.isUserInteractionEnabled = true
            }
        }        
    }
    
    @objc func stopButtonPressed() {
        self.viewModel.stopButtonPressed()
    }
}

