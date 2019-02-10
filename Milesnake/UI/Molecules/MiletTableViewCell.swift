//
//  MiletTableViewCell.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2018/12/31.
//  Copyright © 2018年 kawaguchi kohei. All rights reserved.
//

import UIKit

class MiletTableViewCell: UITableViewCell {
    private let mileView = MileView()

    private var number: Int = 0 {
        willSet {
            mileView.number = newValue
        }
    }

    private let verticalLineView = UIView().then {
        $0.backgroundColor = Color.black10
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = TextStyle.make(weight: .bold, size: .big)
        $0.textColor = Color.textBlack
        $0.numberOfLines = 0
    }

    private let detailLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = TextStyle.make(weight: .medium, size: .medium)
        $0.textColor = Color.black60
        $0.numberOfLines = 0
    }

    private struct Const {
        static let contentLayoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let mileSize = CGSize(width: 45, height: 45)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView: do {
           contentView.insetsLayoutMarginsFromSafeArea = false
            contentView.layoutMargins = Const.contentLayoutMargins
            selectionStyle = .none

            contentView.addSubview(verticalLineView)
            contentView.addSubview(mileView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(detailLabel)
        }

        setupConstraint: do {
            mileView.snp.makeConstraints {
                $0.size.equalTo(Const.mileSize)
                $0.centerY.equalToSuperview()
                $0.left.equalTo(contentView.layoutMargins)
            }

            titleLabel.snp.makeConstraints {
                $0.left.equalTo(mileView.snp.right).offset(40)
                $0.right.equalTo(contentView.layoutMargins)
                $0.top.equalTo(contentView.layoutMargins)
            }

            detailLabel.snp.makeConstraints {
                $0.left.equalTo(titleLabel)
                $0.top.equalTo(titleLabel.snp.bottom).offset(4)
                $0.right.equalTo(titleLabel)
                $0.bottom.equalTo(contentView.layoutMargins)
            }
        }
    }

    func configure(number: Int, title: String?, detail: String?, shouldShowLine: Bool) {
        mileView.number = number
        titleLabel.text = title
        detailLabel.text = detail

        if shouldShowLine {
            verticalLineView.snp.remakeConstraints {
                $0.width.equalTo(2)
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.centerX.equalTo(mileView)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
