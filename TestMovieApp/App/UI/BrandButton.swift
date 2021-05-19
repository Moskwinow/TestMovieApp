//
//  BrandButton.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 18.05.2021.
//

import UIKit

final class BrandButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                setTitleColor(.white, for: .normal)
                backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            } else {
                setTitleColor(.white, for: .normal)
                backgroundColor = .clear
            }
        }
    }
    
    // MARK: -  Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = .boldSystemFont(ofSize: 17)
        isUserInteractionEnabled = true
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBorder()
    }
    
    private func addBorder() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
