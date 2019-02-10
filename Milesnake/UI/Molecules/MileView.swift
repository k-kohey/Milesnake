//
//  MileView.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2018/12/31.
//  Copyright © 2018年 kawaguchi kohei. All rights reserved.
//

import UIKit
import Then
import SnapKit

final class MileView: UIView {
    var number: Int = 0 {
        willSet {
            numberLabel.text = String(newValue)
        }
    }

    var numberLabel = UILabel().then {
        $0.textColor = Color.white
        $0.font = TextStyle.make(weight: .bold, size: .big)
        $0.textAlignment = .center
    }

    init() {
        super.init(frame: .zero)

        setupView: do {
            addSubview(numberLabel)
            setShadow()
        }

        setupConstraint: do {
            numberLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let startColor = Color.gold
        let endColor = Color.pink

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x:0.0,y:0.5)
        gradientLayer.endPoint = CGPoint(x:1,y:0.5)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)

        gradientLayer.cornerRadius = bounds.width * 0.5
        layer.cornerRadius = bounds.width * 0.5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
