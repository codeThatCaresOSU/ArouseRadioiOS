//
//  ViewController.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/15/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import UIKit
import UIImageColors

class RadioController: UIViewController {
    
    private var timer = Timer()
    private var viewModel: RadioViewModel!
    
    init(viewModel: RadioViewModel) {
        super.init(nibName: nil, bundle: nil)
         
        self.viewModel = viewModel
        self.viewModel?.updateUISubject?.subscribe() { (event) in
            self.updateUI()
        }
    }
     
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var albumArt: UIImageView = {
        let image = UIImage(named: "drake")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        
        
        image?.getColors() { colors in
            self.view.backgroundColor = colors?.background
            self.liveLabel.textColor = colors?.primary
            self.albumArt.layer.borderColor = colors?.secondary.cgColor
        }
        
        return imageView
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play/pause", for: .normal)
        button.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:0.4)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        label.text = self.viewModel?.liveLabel
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.preferredMaxLayoutWidth = 50
        return label
    }()
    
    private lazy var songLabel: UILabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center

        
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center

        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
        self.setupConstraints()
        self.view.backgroundColor = .black
    }
    
    private func addSubViews() {
        self.view.addSubview(self.darkView)
        self.view.addSubview(self.albumArt)
        self.view.addSubview(self.liveLabel)
        self.view.addSubview(self.playPauseButton)
        self.view.addSubview(self.songLabel)
    }
    
    private func setupColorTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [ weak self ] _ in
            if let controller = self {
                self?.changeBackgroundToRandomColor(controller: controller)
            }
        }
    }
    
    private func setupConstraints() {
        let size = self.view.frame.width * 0.75
        
        self.albumArt.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.albumArt.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -64).isActive = true
        self.albumArt.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.albumArt.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        self.playPauseButton.centerXAnchor.constraint(equalTo: self.albumArt.centerXAnchor).isActive = true
        self.playPauseButton.centerYAnchor.constraint(equalTo: self.albumArt.centerYAnchor).isActive = true
        self.playPauseButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.playPauseButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        // Make the album art a circle
        self.albumArt.layer.cornerRadius = size / 2
        self.playPauseButton.layer.cornerRadius = size / 2
        
        
        self.liveLabel.centerXAnchor.constraint(equalTo: self.albumArt.centerXAnchor, constant: 0).isActive = true
        self.liveLabel.topAnchor.constraint(equalTo: self.albumArt.bottomAnchor, constant: 8).isActive = true
        self.liveLabel.widthAnchor.constraint(equalTo: self.albumArt.widthAnchor).isActive = true
        self.liveLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.songLabel.topAnchor.constraint(equalTo: self.liveLabel.bottomAnchor, constant: 16).isActive = true
        self.songLabel.centerXAnchor.constraint(equalTo: self.liveLabel.centerXAnchor, constant: 0).isActive = true
        self.songLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
        self.songLabel.heightAnchor.constraint(equalTo: self.liveLabel.heightAnchor).isActive = true
        
//        self.artistLabel.topAnchor.constraint(equalTo: self.songLabel.bottomAnchor, constant: 16).isActive = true
//        self.artistLabel.centerXAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>)
//
        self.controlAnimations()
    }
    
    public func updateUI() {
        //self.liveLabel.text = self.viewModel?.liveLabel
        //self.albumArt.image = self.viewModel.nowPlayingAlbumArt
        self.songLabel.text = self.viewModel.nowPlayingSong ?? ""
        
        if let newAlbumArt = self.viewModel.nowPlayingAlbumArt {
            self.albumArt.image = newAlbumArt
            if newAlbumArt.size.width > 0.0 {
                newAlbumArt.getColors() { [weak self] colors in
                    if let self = self {
                        self.liveLabel.textColor = colors?.primary
                        self.view.backgroundColor = colors?.background
                        self.songLabel.textColor = colors?.detail
                    }
                }
            }
        }
    }
    
    private func controlAnimations() {
    }
    
    @objc private func playButtonPressed() { //Factor all of this into the ViewModel if possible
        if !self.viewModel.isPlaying {
            playPauseButton.backgroundColor = .clear
            rotate()
            setupColorTimer()
            self.viewModel.playButtonPressed()
        } else {
            playPauseButton.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:0.4)
            stopRotating()
            timer.invalidate()
            self.viewModel.stopButtonPressed()
            self.viewModel.stopButtonPressed()
        }        
    }
    
    private func changeBackgroundToRandomColor(controller: RadioController) {
            let animation = CABasicAnimation(keyPath: "borderColor")
            let randomColor = UIColor.random()
            
            animation.fromValue = controller.albumArt.layer.borderColor
            animation.toValue = randomColor.cgColor
            animation.duration = 1.75

            controller.albumArt.layer.add(animation, forKey: "borderColor")
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
