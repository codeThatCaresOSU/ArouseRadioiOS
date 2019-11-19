//
//  ViewController.swift
//  ArouseRadio
//
//  Created by Jared Williams on 1/15/19.
//  Copyright © 2019 Jared Williams. All rights reserved.
//

import UIKit
import UIImageColors
import SafariServices

class RadioController: UIViewController {
    
    private var timer = Timer()
    private var viewModel: RadioViewModel!
    private let playImage = UIImage(named: "play")!.withRenderingMode(.alwaysTemplate)
    private let pauseImage = UIImage(named: "pause")!.withRenderingMode(.alwaysTemplate)
    
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
        button.setImage(playImage, for: .normal)
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
        label.font = UIFont.boldSystemFont(ofSize: 35)
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
    
    private lazy var albumLabel: UILabel = {
       let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center

        
        return label
    }()
    
    private lazy var arouseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Visit Arouse Radio", for: .normal)
        button.addTarget(self, action: #selector(self.arouseButtonPressed), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubViews()
        self.setupConstraints()
        self.view.backgroundColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        // Set up mask around button
        let mask = CAShapeLayer()
        mask.frame = view.bounds
        let radius: CGFloat = 30.0
        let midX = albumArt.bounds.midX
        let midY = albumArt.bounds.midY
        let rect = CGRect(x: midX - radius, y: midY - radius, width: 2 * radius, height: 2 * radius)
        let circlePath = UIBezierPath(ovalIn: rect)
        let path = UIBezierPath(rect: view.bounds)
        path.append(circlePath)
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        mask.path = path.cgPath
        let maskBorder = CustomLayer(maskLayer: mask)
        albumArt.layer.mask = mask
        albumArt.layer.addSublayer(maskBorder)
    }
    
    private func addSubViews() {
        self.view.addSubview(self.darkView)
        self.view.addSubview(self.albumArt)
        self.view.addSubview(self.playPauseButton)
        self.view.addSubview(self.songLabel)
        self.view.addSubview(self.artistLabel)
        self.view.addSubview(self.albumLabel)
        self.view.addSubview(self.arouseButton)
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
        self.albumArt.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        self.albumArt.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.albumArt.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        self.playPauseButton.centerXAnchor.constraint(equalTo: self.albumArt.centerXAnchor).isActive = true
        self.playPauseButton.centerYAnchor.constraint(equalTo: self.albumArt.centerYAnchor).isActive = true
        self.playPauseButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.playPauseButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        // Make the album art a circle
        self.albumArt.layer.cornerRadius = size / 2
        self.playPauseButton.layer.cornerRadius = size / 2
        
        self.songLabel.topAnchor.constraint(equalTo: self.albumArt.bottomAnchor, constant: 40).isActive = true
        self.songLabel.centerXAnchor.constraint(equalTo: self.albumArt.centerXAnchor, constant: 0).isActive = true
        self.songLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.songLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.artistLabel.topAnchor.constraint(equalTo: self.songLabel.bottomAnchor, constant: 8).isActive = true
        self.artistLabel.centerXAnchor.constraint(equalTo: self.songLabel.centerXAnchor).isActive = true
        self.artistLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        self.artistLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.albumLabel.bottomAnchor.constraint(equalTo: self.songLabel.topAnchor, constant: -8).isActive = true
        self.albumLabel.centerXAnchor.constraint(equalTo: self.songLabel.centerXAnchor).isActive = true
        self.albumLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        self.albumLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.arouseButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        self.arouseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.arouseButton.widthAnchor.constraint(equalToConstant: self.view.frame.width - 16).isActive = true
        self.arouseButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        

        self.controlAnimations()
    }
    
    public func updateUI() {
        //self.liveLabel.text = self.viewModel?.liveLabel
        //self.albumArt.image = self.viewModel.nowPlayingAlbumArt
        self.songLabel.text = self.viewModel.nowPlayingSong ?? ""
        self.artistLabel.text = self.viewModel.nowPlayingArtist ?? ""
        self.albumLabel.text = self.viewModel.nowPlayingAlbum ?? ""
        
        if let newAlbumArt = self.viewModel.nowPlayingAlbumArt {
            /*
             Uncomment the next lines to use the default album artwork for testing
            */
//        if var newAlbumArt = self.viewModel.nowPlayingAlbumArt {
//            self.songLabel.text = "Song"
//            self.artistLabel.text = "Artist"
//            self.albumLabel.text = "Album"
//            newAlbumArt = albumArt.image!
            
//            self.albumArt.image = newAlbumArt
            if newAlbumArt.size.width > 0.0 {
                newAlbumArt.getColors() { [weak self] colors in
                    if let self = self {
                        self.view.backgroundColor = colors?.background
                        self.songLabel.textColor = colors?.primary
                        self.playPauseButton.tintColor = colors?.primary
                        self.artistLabel.textColor = colors?.detail
                        self.albumLabel.textColor = colors?.detail

                        self.arouseButton.layer.cornerRadius = 25
                        self.arouseButton.layoutSubviews()
                    }
                }
            }
        }
    }
    
    private func controlAnimations() {
    }
    
    @objc private func playButtonPressed() { //Factor all of this into the ViewModel if possible
        self.viewModel.playButtonPressed()
        
        if !self.viewModel.isPlaying {
            rotate()
            playPauseButton.setImage(pauseImage, for: .normal)
            setupColorTimer()
        } else {
            stopRotating()
            playPauseButton.setImage(playImage, for: .normal)
            timer.invalidate()
        }        
    }
    
    private func changeBackgroundToRandomColor(controller: RadioController) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        let randomColor = UIColor.random()
        
        animation.fromValue = controller.albumArt.layer.borderColor
        animation.toValue = randomColor.cgColor
        animation.duration = 1.75
        controller.albumArt.layer.add(animation, forKey: "borderColor")
        controller.albumArt.layer.borderColor = randomColor.cgColor
        
        controller.albumArt.layer.sublayers?.forEach { layer in
            if layer is CustomLayer {
                (layer as? CustomLayer)?.layoutMySublayers(randomColor: randomColor.cgColor)
                (layer as? CustomLayer)?.newBorder.strokeColor = randomColor.cgColor
            }
        }
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
    
    @objc private func arouseButtonPressed() {
        let arouseUrl = URL(string: "http://arouseosu.com")!
        let sfViewController = SFSafariViewController(url: arouseUrl)
        self.present(sfViewController, animated: true)
        
    }
}
class CustomLayer: CALayer {

    private var path: CGPath?
    private var borderSet: Bool = false
    var borderCol: CGColor?
    lazy var newBorder: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 5
        layer.path = self.path
        layer.fillColor = nil
        return layer
    }()

    init(maskLayer: CAShapeLayer) {
        super.init()
        
        self.path = maskLayer.path
        self.frame = maskLayer.frame
        self.bounds = maskLayer.bounds
        self.mask = maskLayer
        self.borderCol = UIColor.green.cgColor
    }

    func layoutMySublayers(randomColor: CGColor) {
        self.sublayers = nil
        self.addSublayer(newBorder)
        addAnimation(randomColor: randomColor)
    }
    
    func addAnimation(randomColor: CGColor){
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = newBorder.strokeColor
        animation.toValue = randomColor
        animation.duration = 1.75
        animation.repeatCount = 0
        animation.autoreverses = true
        newBorder.add(animation, forKey: "strokeColor")
    }

    required override init(layer: Any) {
        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
