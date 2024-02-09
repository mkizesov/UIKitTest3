//
//  ViewController.swift
//  UIKitTest3
//
//  Created by M K on 09.02.2024.
//

import UIKit

class ViewController: UIViewController {
    let squareContainerView = UIView()
    let squareView = UIView()
    let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        layoutViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
                
        squareContainerView.backgroundColor = .clear
        view.addSubview(squareContainerView)
        
        squareView.backgroundColor = .systemBlue
        squareView.layer.cornerRadius = 10
        squareContainerView.addSubview(squareView)
 
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside])
        view.addSubview(slider)
    }
    
    func layoutViews() {
        squareContainerView.translatesAutoresizingMaskIntoConstraints = false
        squareView.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            squareContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            squareContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            squareContainerView.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            squareContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            squareView.widthAnchor.constraint(equalToConstant: 100),
            squareView.heightAnchor.constraint(equalToConstant: 100),
            squareView.leadingAnchor.constraint(equalTo: squareContainerView.leadingAnchor),
            squareView.topAnchor.constraint(equalTo: squareContainerView.topAnchor),
            
            slider.topAnchor.constraint(equalTo: squareContainerView.bottomAnchor, constant: 40),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let progress = CGFloat(sender.value)
        animateSquareView(toProgress: progress, animated: false)
    }
    
    @objc func sliderTouchEnded(_ sender: UISlider) {
        animateSquareViewToEnd()
    }
    
    private func animateSquareView(toProgress progress: CGFloat, animated: Bool) {
        let initialScale: CGFloat = 1.0
        let finalScale: CGFloat = 1.5
        let scale = initialScale + (finalScale - initialScale) * progress
        
        let rotationAngle = CGFloat.pi / 2 * progress
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: scale, y: scale)
        
        squareView.transform = rotationTransform

        let maxTranslationX = squareContainerView.frame.width - (100 * finalScale)
        squareContainerView.transform = CGAffineTransform(translationX: maxTranslationX * progress, y: 0)
        
        if animated {
            UIView.animate(withDuration: 1.0) {
                self.squareContainerView.transform = CGAffineTransform(translationX: maxTranslationX * progress, y: 0)
                self.squareView.transform = rotationTransform
            }
        }
    }
    
    private func animateSquareViewToEnd() {
        UIView.animate(withDuration: 1.0 - TimeInterval(slider.value), delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.slider.setValue(1, animated: true)
            self.animateSquareView(toProgress: 1.0, animated: false)
        }, completion: nil)
    }
}
