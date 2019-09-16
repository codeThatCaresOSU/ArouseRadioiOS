//
//  ViewController.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/15/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import UIKit

class RadioController: UIViewController {
    
    private lazy var viewModel: RadioViewModel = RadioViewModel(delegate: self)
    
    private lazy var albumArt: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "beatles"))
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        return imageView
    }()
    
    private lazy var darkView: UIView = {
        let view = UIView()
        
        view.frame = self.view.frame
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
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
        self.setupColorTimer()
        self.view.backgroundColor = .black
        playButtonPressed()
    }
    
    private func addSubViews() {
        self.view.addSubview(self.darkView)
        self.view.addSubview(self.albumArt)
        self.view.addSubview(self.liveLabel)
    }
    
    private func setupColorTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [ weak self ] _ in
            if let controller = self {
                self?.changeBackgroundToRandomColor(controller: controller)
            }
        }
        
        timer.fire()
    }
    
    private func setupConstraints() {
        let size = self.view.frame.width * 0.75
        
        self.albumArt.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.albumArt.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.albumArt.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.albumArt.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        // Make the album art a circle
        self.albumArt.layer.cornerRadius = size / 2
        
        self.liveLabel.centerXAnchor.constraint(equalTo: self.albumArt.centerXAnchor, constant: 0).isActive = true
        self.liveLabel.topAnchor.constraint(equalTo: self.albumArt.bottomAnchor, constant: 8).isActive = true
        self.liveLabel.widthAnchor.constraint(equalTo: self.albumArt.widthAnchor).isActive = true
        self.liveLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.controlAnimations()
    }
    
    public func updateUI() {
        self.liveLabel.text = self.viewModel.liveLabel
    }
    
    private func controlAnimations() {
    }
    
    @objc private func playButtonPressed() { //Factor all of this into the ViewModel if possible
        rotate()
        if !self.viewModel.isPlaying {
            self.viewModel.playButtonPressed()
        } else {
            self.viewModel.stopButtonPressed()
        }        
    }
    
    @objc func stopButtonPressed() {
        stopRotating()
        self.viewModel.stopButtonPressed()
    }
    
    private func changeBackgroundToRandomColor(controller: RadioController) {
        UIView.animate(withDuration: 1.25, delay: 0.0, options: .allowUserInteraction, animations: {
            controller.view.backgroundColor = UIColor.random()
        }, completion: nil)
    }
    
    func rotate() {
        let kAnimationKey = "rotation"
        
        if albumArt.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = 5
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(.pi * 2.0)
            albumArt.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if albumArt.layer.animation(forKey: kAnimationKey) != nil {
            albumArt.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
