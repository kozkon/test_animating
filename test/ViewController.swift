//
//  ViewController.swift
//  test
//
//  Created by Константин Козлов on 18.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var isAnimated = false
    private let gradient = CAGradientLayer()
    
    private let imageArray = [UIImage(named: "1"),
                              UIImage(named: "2"),
                              UIImage(named: "3"),
                              UIImage(named: "4"),
                              UIImage(named: "5")].compactMap { $0 }
    private var timer: Timer?
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func actionButton(_ sender: UIButton) {
        isAnimated = !isAnimated
        
        if isAnimated {
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animateImage), userInfo: nil, repeats: true)
                timer?.fire()
            }
            
            self.animationButton()
            
        } else {
            timer?.invalidate()
            timer = nil
            self.gradient.removeAllAnimations()
            self.startButton.setTitle("Start", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.imageArray.randomElement()
        self.startButton.layer.cornerRadius = self.startButton.frame.height / 2
        self.startButton.clipsToBounds = true
        
        self.configureAnimationButton()
    }
    
    func configureAnimationButton(){
        self.gradient.frame = self.startButton.bounds
        self.gradient.colors = [UIColor.orange.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor]
        self.gradient.startPoint = CGPoint(x: -1.0, y: 0)
        self.gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.gradient.locations = [0, 0.5, 1.0]
        self.startButton.layer.insertSublayer(self.gradient, at: 0)
        self.startButton.setTitleColor(.white, for: .normal)
        self.startButton.setTitle("Start", for: .normal)
    }
    
    func animationButton(){
        configureAnimationButton()
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0, 0.5, 1.0]
        gradientAnimation.toValue = [0.5, 1.0, 1.5]
        gradientAnimation.duration = 2
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = Float.infinity
        self.gradient.add(gradientAnimation, forKey: nil)
        self.startButton.setTitle("Stop", for: .normal)
    }
    
    @objc func animateImage() {
        let currentImage = imageView.image
        var images = imageArray
        images.removeAll(where: { $0 == currentImage })
        let newImage = images.randomElement()
        
        UIView.transition(with: self.imageView,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: {
            self.imageView.image = newImage
        }, completion: nil)
    }
}
