//
//  SingleLineSectionView.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2019/01/01.
//  Copyright © 2019年 kawaguchi kohei. All rights reserved.
//

import UIKit

class SingleLineSectionView: UITableViewHeaderFooterView {
    private let verticalLineView = UIView().then {
        $0.backgroundColor = Color.black10
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = TextStyle.make(weight: .medium, size: .medium)
        $0.textColor = Color.black60
    }

    var text: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView: do {
            contentView.backgroundColor = .white
            contentView.addSubview(verticalLineView)
            contentView.addSubview(titleLabel)
        }
        setupConstraint: do {
            titleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(40 + 45 + 16)
            }

            verticalLineView.snp.remakeConstraints {
                $0.width.equalTo(2)
                $0.top.bottom.equalToSuperview()
                $0.left.equalToSuperview().offset(16 + 45 / 2)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
