//
//  GradientCell.swift
//  ImageFeed
//
//  Created by User on 22.02.2023.
//

import UIKit

class GradientCell: UIView {
    
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGredientColors()
        }
    }
    
    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGredientColors()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        setupGredientColors()
    }
    
    private func setupGredientColors() {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
}
